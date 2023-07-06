# Kubernetes_Terraform
Après avoir déployer l'infra il suffit de rediriger l'output des clés dans des fichiers pour lesquels les droits seront modifiés

- terraform output -raw Cle_publique > id_rsa.pub

- terraform output -raw Cle_privee > id_rsa

- chmod 400 id_rsa

- ssh -i id_rsa user@<IP>