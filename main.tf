terraform {
 required_providers {
   yandex = {
     source = "yandex-cloud/yandex"
   }
 }
 required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}


# https://cloud.yandex.ru/docs/data-proc/operations/cluster-create
resource "yandex_dataproc_cluster" "default" {
  bucket              = "dataproc-bucket-test"
  name                = var.project_name
  description         = var.project_name
  service_account_id  = yandex_iam_service_account.dataproc-test.id
  zone_id             = var.yc_zone
  # security_group_ids  = beta
  deletion_protection = false

  cluster_config {
    version_id = var.dataproc_version

    hadoop {
      services   = ["HDFS", "YARN", "SPARK", "TEZ", "MAPREDUCE", "HIVE"]
      properties = { }
      ssh_public_keys = [
        file("~/.ssh/id_rsa.pub")
      ]
    }

    subcluster_spec {
      name = "MASTERNODE"
      role = "MASTERNODE"
      resources {
        resource_preset_id = "s2.small"
#        disk_type_id       = "network-ssd"
        disk_size          = 64
      }
      subnet_id   = yandex_vpc_subnet.default.id
      hosts_count = 1
    }

    subcluster_spec {
      name = "DATANODE"
      role = "DATANODE"
      resources {
        resource_preset_id = "s2.small"
#        disk_type_id       = "network-ssd"
        disk_size          = 64
      }
      subnet_id   = yandex_vpc_subnet.default.id
      hosts_count = 1
    }

    subcluster_spec {
      name = "COMPUTENODE"
      role = "COMPUTENODE"
      resources {
        resource_preset_id = "s2.small"
#        disk_type_id       = "network-ssd"
        disk_size          = 64
      }
      subnet_id   = yandex_vpc_subnet.default.id
      hosts_count = 1
   }
  }
}
