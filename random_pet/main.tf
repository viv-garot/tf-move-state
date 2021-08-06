resource "random_pet" "name" {
  length    = "4"
  separator = "-"
}

output "random_pet" {
  value = random_pet.name.id
}
