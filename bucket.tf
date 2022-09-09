resource "yandex_storage_bucket" "default" {
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.bucket-creator
  ]

  bucket     = var.bucket_name
  access_key = yandex_iam_service_account_static_access_key.dataproc.access_key
  secret_key = yandex_iam_service_account_static_access_key.dataproc.secret_key
}
