resource "yandex_iam_service_account" "dataproc-test" {
  name        = var.project_name
  description = "Service account for DataProc"
}

resource "yandex_resourcemanager_folder_iam_member" "dataproc" {
  folder_id  = var.yc_folder_id
  role       = "dataproc.agent"
  member     = "serviceAccount:${yandex_iam_service_account.dataproc-test.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "bucket-creator" {
  folder_id  = var.yc_folder_id
  role       = "editor"
  member     = "serviceAccount:${yandex_iam_service_account.dataproc-test.id}"
}

resource "yandex_iam_service_account_static_access_key" "dataproc" {
  service_account_id = yandex_iam_service_account.dataproc-test.id
}
