#data "yandex_dataproc_cluster" "dataproc" {
#name = "dataproc"
#}

#output "resources" {
#  value = "${data.yandex_dataproc_cluster.dataproc.cluster_config.subcluster_spec.resources.resource_preset_id}"
#}
