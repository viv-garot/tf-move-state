# tf-move-state

## Description
Learn move state

## Pre-requirements

* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 
* [Terraform cli](https://learn.hashicorp.com/tutorials/terraform/install-cli)


## How to use this repo

- Clone
- Run

---

### Clone the repo

```
git clone https://github.com/viv-garot/tf-move-state
```

### Change directory

```
cd tf-move-state/sample
```

### Run

* Init and apply:

```
terraform init && terraform apply --auto-approve
```

_sample_:

```
terraform init && terraform apply --auto-approve

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/random...
- Finding latest version of hashicorp/null...
- Installing hashicorp/random v3.1.0...
- Installed hashicorp/random v3.1.0 (signed by HashiCorp)
- Installing hashicorp/null v3.1.0...
- Installed hashicorp/null v3.1.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.hello will be created
  + resource "null_resource" "hello" {
      + id = (known after apply)
    }

  # random_pet.name will be created
  + resource "random_pet" "name" {
      + id        = (known after apply)
      + length    = 4
      + separator = "-"
    }

Plan: 2 to add, 0 to change, 0 to destroy.
random_pet.name: Creating...
random_pet.name: Creation complete after 0s [id=mentally-recently-brave-catfish]
null_resource.hello: Creating...
null_resource.hello: Provisioning with 'local-exec'...
null_resource.hello (local-exec): Executing: ["/bin/sh" "-c" "echo Hello mentally-recently-brave-catfish"]
null_resource.hello (local-exec): Hello mentally-recently-brave-catfish
null_resource.hello: Creation complete after 0s [id=2460983977281198710]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```


* Check state:

```
terraform state list
```

_sample_:

```
terraform state list
null_resource.hello
random_pet.name
```

* Update the code to use the module:

```
cp updated-main.txt main.tf
```

* Run terraform init again to initialize the module:

```
terraform init
```

_sample_:

```
terraform init
Initializing modules...
- mymodule in ../random_pet

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/null from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Using previously-installed hashicorp/null v3.1.0
- Using previously-installed hashicorp/random v3.1.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

* Use terraform state mv command to move the random_pet code in the state:

```
terraform state mv random_pet.name module.mymodule.random_pet.name
```

_sample_:

```
terraform state mv random_pet.name module.mymodule.random_pet.name
Move "random_pet.name" to "module.mymodule.random_pet.name"
Successfully moved 1 object(s).
```

* Run terraform apply again. Confirm there is no change:

```
terraform apply
```


_sample_:

```
terraform apply
module.mymodule.random_pet.name: Refreshing state... [id=mentally-recently-brave-catfish]
null_resource.hello: Refreshing state... [id=2460983977281198710]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

* Check state once again:

```
terraform state list
```

_sample_:

```
terraform state list
null_resource.hello
module.mymodule.random_pet.name
```

* Run terraform destroy and confirm both resources are destroyed

```
terraform destroy
```

_sample_:

```
terraform destroy
module.mymodule.random_pet.name: Refreshing state... [id=mentally-recently-brave-catfish]
null_resource.hello: Refreshing state... [id=2460983977281198710]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # null_resource.hello will be destroyed
  - resource "null_resource" "hello" {
      - id = "2460983977281198710" -> null
    }

  # module.mymodule.random_pet.name will be destroyed
  - resource "random_pet" "name" {
      - id        = "mentally-recently-brave-catfish" -> null
      - length    = 4 -> null
      - separator = "-" -> null
    }

Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

null_resource.hello: Destroying... [id=2460983977281198710]
null_resource.hello: Destruction complete after 0s
module.mymodule.random_pet.name: Destroying... [id=mentally-recently-brave-catfish]
module.mymodule.random_pet.name: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.
```

#### Note

* Q. : What will happen if we didn't move the state after updating the code  ?
* A. : The moved resource would need to be re-created (destroyed then created)

_sample with same code executed, but state mv command omited_ :
```
terraform apply
random_pet.name: Refreshing state... [id=similarly-suddenly-tops-sunfish]
null_resource.hello: Refreshing state... [id=1258574324040771526]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  - destroy

Terraform will perform the following actions:

  # random_pet.name will be destroyed
  - resource "random_pet" "name" {
      - id        = "similarly-suddenly-tops-sunfish" -> null
      - length    = 4 -> null
      - separator = "-" -> null
    }

  # module.mymodule.random_pet.name will be created
  + resource "random_pet" "name" {
      + id        = (known after apply)
      + length    = 4
      + separator = "-"
    }

Plan: 1 to add, 0 to change, 1 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_pet.name: Destroying... [id=similarly-suddenly-tops-sunfish]
random_pet.name: Destruction complete after 0s
module.mymodule.random_pet.name: Creating...
module.mymodule.random_pet.name: Creation complete after 0s [id=extremely-solely-supreme-leech]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
```
