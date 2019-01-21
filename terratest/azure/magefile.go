// +build mage

// Build a script to format and run tests of a Terraform module project
package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/magefile/mage/mg"
	"github.com/magefile/mage/sh"
)

// Default is the default target when the command executes `mage` in Cloud Shell
var Default = Full

// Full runs Clean, Format, Unit and Integration in sequence
func Full() {
	mg.Deps(Unit)
	mg.Deps(Integration)
}

var labID string

// LookupLab finds the GUID of the correct Azure lab subscription to provision test resources in
func LookupLab() error {
	fmt.Println("Looking up lab subscription...")
	rawLabID, errAz := exec.Command("sh", "-c", "az account list 2>/dev/null | jq -r '.[] | select( .name == \"LAB27\" ) | .id'").Output()
	if errAz != nil {
		return errAz
	}
	labID = strings.TrimSpace(string(rawLabID))
	return nil
}

// SelectLab selects the Azure lab subscription
func SelectLab() error {
	mg.Deps(LookupLab)
	fmt.Println("Selecting lab subscription...")
	return sh.Run("az", "account", "set", fmt.Sprintf("--subscription=%s", labID))
}

// Unit runs unit tests
func Unit() error {
	mg.Deps(Clean)
	mg.Deps(Format)
	mg.Deps(SelectLab)
	fmt.Println("Running unit tests...")
	return sh.Run("go", "test", "./test/", "-run", "TestUT_", "-v")
}

// Integration runs integration tests
func Integration() error {
	mg.Deps(Clean)
	mg.Deps(Format)
	mg.Deps(SelectLab)
	fmt.Println("Running integration tests...")
	return sh.Run("go", "test", "./test/", "-run", "TestIT_", "-v")
}

// Format formats both Terraform code and Go code
func Format() error {
	fmt.Println("Formatting...")
	if err := sh.Run("terraform", "fmt", "."); err != nil {
		return err
	}
	return sh.Run("go", "fmt", "./test/")
}

// Clean removes temporary build and test files
func Clean() error {
	fmt.Println("Cleaning...")
	return filepath.Walk(".", func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() && info.Name() == "vendor" {
			return filepath.SkipDir
		}
		if info.IsDir() && info.Name() == ".terraform" {
			os.RemoveAll(path)
			fmt.Printf("Removed \"%v\"\n", path)
			return filepath.SkipDir
		}
		if !info.IsDir() && (info.Name() == "terraform.tfstate" ||
			info.Name() == "terraform.tfplan" ||
			info.Name() == "terraform.tfstate.backup") {
			os.Remove(path)
			fmt.Printf("Removed \"%v\"\n", path)
		}
		return nil
	})
}
