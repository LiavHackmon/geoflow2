resource "aws_s3_bucket" "geojson_bucket" {
  bucket = "geojson-bucket-${random_id.bucket_suffix.hex}"
  force_destroy = true

  tags = {
    Name = "GeoJSON Bucket"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

