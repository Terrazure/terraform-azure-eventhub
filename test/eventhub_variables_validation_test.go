package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

type VariableTestCase struct {
	variableValue interface{}
	errorExpected bool
}

func verifyTestCase(t *testing.T, err error, testCase VariableTestCase, errorMessageExpected string) {
	if err != nil && testCase.errorExpected {
		assert.Contains(t, err.Error(), errorMessageExpected)
	} else if err == nil && testCase.errorExpected == true {
		t.Errorf("%v should not be an allowed value", testCase.variableValue)
	} else if err != nil && testCase.errorExpected == false {
		if strings.Contains(err.Error(), errorMessageExpected) {
			t.Errorf("%v should be an allowed value", testCase.variableValue)
		} else {
			t.Errorf("Unexpected error %v", err)
		}
	}
}

func TestEHNSkuValidation(t *testing.T) {
	t.Parallel()
	expectedErrorMessage := "Invalid sku. Valid options for sku are Basic or Standard."
	testCases := []VariableTestCase{
		{variableValue: "Premmium", errorExpected: true},
		{variableValue: "Basic", errorExpected: false},
		{variableValue: 5.5, errorExpected: true},
		{variableValue: "Standard", errorExpected: false},
		{variableValue: "Std", errorExpected: true},
	}

	for _, testCase := range testCases {
		t.Run(fmt.Sprintf("Sku-'%s'", testCase.variableValue), func(subTest *testing.T) {
			testCase := testCase
			subTest.Parallel()

			terraformDir := test_structure.CopyTerraformFolderToTemp(t, "..", "/test/variables-validation")
			tempRootFolderPath, _ := filepath.Abs(filepath.Join(terraformDir, "../../.."))
			defer os.RemoveAll(tempRootFolderPath)

			options := &terraform.Options{
				TerraformDir: terraformDir,
				Vars: map[string]interface{}{
					"sku": testCase.variableValue,
				},
			}

			_, err := terraform.InitAndPlanE(subTest, options)

			verifyTestCase(subTest, err, testCase, expectedErrorMessage)
		})
	}
}

func TestEHNCapacityValidation(t *testing.T) {
	t.Parallel()
	expectedErrorMessage := "The Capacity of the Eventhub Namespace must be between 1 and 20."
	testCases := []VariableTestCase{
		{variableValue: -1, errorExpected: true},
		{variableValue: 0, errorExpected: true},
		{variableValue: 1000, errorExpected: true},
		{variableValue: 18, errorExpected: false},
		{variableValue: 33, errorExpected: true},
	}

	for _, testCase := range testCases {
		t.Run(fmt.Sprintf("Capacity-'%v'", testCase.variableValue), func(subTest *testing.T) {
			testCase := testCase
			subTest.Parallel()

			terraformDir := test_structure.CopyTerraformFolderToTemp(t, "..", "/test/variables-validation")
			tempRootFolderPath, _ := filepath.Abs(filepath.Join(terraformDir, "../../.."))
			defer os.RemoveAll(tempRootFolderPath)

			options := &terraform.Options{
				TerraformDir: terraformDir,
				Vars: map[string]interface{}{
					"capacity": testCase.variableValue,
				},
			}

			_, err := terraform.InitAndPlanE(subTest, options)

			verifyTestCase(subTest, err, testCase, expectedErrorMessage)
		})
	}
}

func TestEHNPartitionsValidation(t *testing.T) {
	t.Parallel()
	expectedErrorMessage := "Invalid number of partitions."
	testCases := []VariableTestCase{
		{variableValue: -1, errorExpected: true},
		{variableValue: 0, errorExpected: true},
		{variableValue: 1000, errorExpected: true},
		{variableValue: 18, errorExpected: false},
		{variableValue: 33, errorExpected: true},
	}

	for _, testCase := range testCases {
		t.Run(fmt.Sprintf("Partitions-'%v'", testCase.variableValue), func(subTest *testing.T) {
			testCase := testCase
			subTest.Parallel()

			terraformDir := test_structure.CopyTerraformFolderToTemp(t, "..", "/test/variables-validation")
			tempRootFolderPath, _ := filepath.Abs(filepath.Join(terraformDir, "../../.."))
			defer os.RemoveAll(tempRootFolderPath)

			options := &terraform.Options{
				TerraformDir: terraformDir,
				Vars: map[string]interface{}{
					"partitions": testCase.variableValue,
				},
			}

			_, err := terraform.InitAndPlanE(subTest, options)

			verifyTestCase(subTest, err, testCase, expectedErrorMessage)
		})
	}
}

func TestEHNRetentionValidation(t *testing.T) {
	t.Parallel()
	expectedErrorMessage := "Invalid number message retention days."
	testCases := []VariableTestCase{
		{variableValue: -1, errorExpected: true},
		{variableValue: 0, errorExpected: true},
		{variableValue: 6, errorExpected: false},
	}

	for _, testCase := range testCases {
		t.Run(fmt.Sprintf("Retention-'%v'", testCase.variableValue), func(subTest *testing.T) {
			testCase := testCase
			subTest.Parallel()

			terraformDir := test_structure.CopyTerraformFolderToTemp(t, "..", "/test/variables-validation")
			tempRootFolderPath, _ := filepath.Abs(filepath.Join(terraformDir, "../../.."))
			defer os.RemoveAll(tempRootFolderPath)

			options := &terraform.Options{
				TerraformDir: terraformDir,
				Vars: map[string]interface{}{
					"retention": testCase.variableValue,
				},
			}

			_, err := terraform.InitAndPlanE(subTest, options)

			verifyTestCase(subTest, err, testCase, expectedErrorMessage)
		})
	}
}
