output "Cle_publique" {
  value     = module.ChildResources.pub
  sensitive = true
}

output "Cle_privee" {
    value   = module.ChildResources.private
    sensitive = true
}