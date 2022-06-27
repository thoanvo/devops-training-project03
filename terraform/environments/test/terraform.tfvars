# Azure subscription vars
subscription_id = ""
client_id = ""
client_secret = ""
tenant_id = ""

# Resource Group/Location
location = "australiaeast"
resource_group = "udacity-thoanvtt-project03-rg"
application_type = "udacity-thoanvtt-project03-app"

# Network
virtual_network_name = "udacity-thoanvtt-project03-vnet"
address_space = ["10.5.0.0/16"]
address_prefix_test = "10.5.0.0/24"

# VM
name_image = "VM"
name_vm = "VM-QA"
name_size = "Standard_B1s"
type_storage = "Standard_LRS"
admin_username = "admin26062022"
admin_password = "P@ssw0rd2022Xyz"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCm5LuEnWBXYqFNXStEVN21PtzszsNYkBMCl+fwvmR8X6KJpKq5jK3uNpGGqMQI+BYUdEMkS/PEgWlfeUmOhVkfR9CnMnV66s3gBZmIFSUmDNQtgN6EqXXyBC+B8fH6QnbTjqmCSX5Ne8XyF2DLP8qDrxYbTCBTBtsZO1SSY8c2dKA3Jyat7tcp+SXZnYskEqrIbsw9aal7ZHaBFqdCEGZ6O52OFXTd7e3Vi1HH+08D0UE2jQF8Eim7n4+S0CszkNCAaEmtwfhi6RlFy3v8nNNC18oQ68gMenuWuYMv/QfnBVwDCcSfFQ7LQW88X3XCNOMOzKmdm9d8uix3cgzvBPxXrsavzlReDGqf50lQ3vixKTiXONmnO22LfphPvs+IVTQYvXQo8TD3XQ0XY9UNr+lRqFeymCpo3UvKuSG9f20fNROplVj6LIOCRaP9QOXkpR6Mnb1+EPcPOiFbQMpuDgkOkZF2In6p0ImKUCD8vStOYl0H2cgncpDRdtGsHPS1saJ2GQBzj5IMhjK6JfmNZXpg/BQH3H157PzkELiJQj//JGewklC9I5bqxpLNL/AICMe5GDrzlXJ5SyXJ5fpj5i7ND81TizjWBOGyRQjP0+PA2/FLb7/kXcDo3+iHsEsJQS7rqyP/oamuIexe/IrGDW1b0sZg5KIn7907U0TIGibRFw== thoan@cc-6800ab99-5777c8b5bd-x7njz"

#public key on pipeline
public_key_path = "/home/vsts/work/_temp/id_rsa.pub"
