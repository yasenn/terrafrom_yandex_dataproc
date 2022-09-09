resource "yandex_iam_service_account" "dataproc" {
  name        = "dataproc"
  description = "service account to manage Dataproc Cluster"
}

data "yandex_resourcemanager_folder" "default" {
  folder_id = "b1g638bkim2da8v3h4ek"
}

resource "yandex_resourcemanager_folder_iam_binding" "dataproc" {
  folder_id = data.yandex_resourcemanager_folder.default.id
  role      = "dataproc.agent"
  members = [
    "serviceAccount:${yandex_iam_service_account.dataproc.id}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "dataproc1" {
  folder_id = data.yandex_resourcemanager_folder.default.id
  role      = "mdb.dataproc.agent"
  members = [
    "serviceAccount:${yandex_iam_service_account.dataproc.id}",
  ]
}


// required in order to create bucket
resource "yandex_resourcemanager_folder_iam_binding" "bucket-creator" {
  folder_id = data.yandex_resourcemanager_folder.default.id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.dataproc.id}",
  ]
}

resource "yandex_iam_service_account_static_access_key" "dataproc" {
  service_account_id = yandex_iam_service_account.dataproc.id
}
