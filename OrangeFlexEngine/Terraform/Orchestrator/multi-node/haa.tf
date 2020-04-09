
## Getting some data first
data "flexibleengine_vpc_subnet_v1" "subnet_v1" {
  name   = "${var.subnet_name}"
 }



resource "flexibleengine_compute_instance_v2" "haa-master" {
  image_id        = "${var.centos_image}"
  name            = "redis-master"
  flavor_id       = "s3.large.4"
  key_pair        = "uipath"
  security_groups = ["${var.default_sec_group}"]
  network {
      uuid        = "${data.flexibleengine_vpc_subnet_v1.subnet_v1.id}"
  }

  user_data       = "${data.template_file.haa-master.rendered}"

}


resource "flexibleengine_compute_instance_v2" "haa-slave" {
  depends_on      = ["flexibleengine_compute_instance_v2.haa-master"]
  name            = "${format("redis-slave-%02d", count.index+1)}"
  image_id        = "${var.centos_image}"
  flavor_id       = "s3.large.4"
  count           = "2"
  key_pair        = "uipath"
  security_groups = ["${var.default_sec_group}"]
  network {
      uuid        = "${data.flexibleengine_vpc_subnet_v1.subnet_v1.id}"
  }

  user_data = "${element(data.template_file.haa-slave.*.rendered, count.index)}"
}

