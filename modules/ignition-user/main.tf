data "ignition_user" "user" {
  name = "core"

  ssh_authorized_keys = [
    "${file(var.public_key)}",
  ]
}
