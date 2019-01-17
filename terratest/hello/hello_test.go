package terratest

import (
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestWebServer(t *testing.T) {
	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../web-server",
	}

	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	url := terraform.Output(t, terraformOptions, "url")

	// Verify that we (eventually) get back a 200 OK with the expected text
	status := 200
	text := "Hello, World"
	retries := 20
	sleep := 15 * time.Second
	errGet := http_helper.HttpGetWithRetryE(t, url, status, text, retries, sleep)
	if errGet == nil {
		// At the end of the test, run `terraform destroy`
		terraform.Destroy(t, terraformOptions)
	}
}
