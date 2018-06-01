output "join" {
  value = "${join("/", slice(split("/", path.module), index(split("/", path.module), "james-lucktaylor-terraform")+1, length(split("/", path.module))))}"
}

# key            = "${join("/", slice(split("/", path.module), index(split("/", path.module), "james-lucktaylor-terraform")+1, length(split("/", path.module))))}/terraform.tfstate"

output "cwd" {
  value = "${path.cwd}"
}

output "module" {
  value = "${path.module}"
}

output "root" {
  value = "${path.root}"
}
