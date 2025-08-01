import boto3
import geojson
import os
import psycopg2

BUCKET_NAME = os.getenv("S3_BUCKET_NAME", "your-bucket-name")
OBJECT_KEY = os.getenv("S3_OBJECT_KEY", "geojson")

def download_file_from_s3(bucket, key, local_file):
    s3 = boto3.client("s3")
    s3.download_file(bucket, key, local_file)
    print(f"Downloaded {key} from bucket {bucket} to {local_file}")

def is_valid_geojson(file_path):
    with open(file_path) as f:
        try:
            gj = geojson.load(f)
            if gj.get("type") in ["Feature", "FeatureCollection", "GeometryCollection"]:
                return True
            else:
                return False
        except Exception as e:
            print("Invalid GeoJSON:", e)
            return False

def insert_into_postgres(file_path):
    conn = psycopg2.connect(
        host=os.getenv("RDS_HOST"),
        database=os.getenv("RDS_DB", "postgres"),
        user=os.getenv("RDS_USER"),
        password=os.getenv("RDS_PASSWORD"),
        port=os.getenv("RDS_PORT", 5432)
    )

    cursor = conn.cursor()
    cursor.execute("CREATE EXTENSION IF NOT EXISTS postgis;")
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS geo_data (
            id SERIAL PRIMARY KEY,
            name TEXT,
            geom GEOMETRY
        );
    """)

    with open(file_path) as f:
        gj = geojson.load(f)
        for feature in gj["features"]:
            name = feature["properties"].get("name", "Unknown")
            coords = feature["geometry"]["coordinates"]
            geom_type = feature["geometry"]["type"]
            wkt = f"{geom_type}({coords[0]} {coords[1]})"

            cursor.execute("""
                INSERT INTO geo_data (name, geom)
                VALUES (%s, ST_GeomFromText(%s, 4326));
            """, (name, wkt))

    conn.commit()
    cursor.close()
    conn.close()
    print("Data inserted into PostgreSQL.")

def main():
    local_file = "downloaded.geojson"

    download_file_from_s3(BUCKET_NAME, OBJECT_KEY, local_file)

    if is_valid_geojson(local_file):
        print("GeoJSON is valid")
        insert_into_postgres(local_file)
    else:
        print("GeoJSON is NOT valid")

if __name__ == "__main__":
    main()

