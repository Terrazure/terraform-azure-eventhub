package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"os"
	"testing"

	helpers "github.com/Terrazure/terratest-helpers"
)

type EventHubtBasicTestCase struct {
	capacity        int
	sku             string
}

func TestBasicConfiguration(t *testing.T) {
	t.Parallel()

	testCases := []EventHubtBasicTestCase{
		{sku: "Basic", capacity: 6},
		{sku: "Standard", capacity: 1},
	}

	for testCaseIndex, testCase := range testCases {
		t.Run(fmt.Sprintf(
			"sku-%s-capacity-%d",
			testCase.sku,
			testCase.capacity),
			func(t *testing.T) {
				testCase := testCase
				testCaseIndex := testCaseIndex
				t.Parallel()

				parallelTerraformDir := helpers.PrepareTerraformParallelTestingDir("./basic", "default", testCaseIndex)
				defer os.RemoveAll(parallelTerraformDir)

				terraformOptions := &terraform.Options{
					TerraformDir: parallelTerraformDir,
					Vars: map[string]interface{}{
						"capacity":       testCase.capacity,
						"sku":            testCase.sku,
					},
				}

				defer terraform.Destroy(t, terraformOptions)
				terraform.InitAndApplyAndIdempotent(t, terraformOptions)
				resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
				name := terraform.Output(t, terraformOptions, "name")
				subscriptionID := terraform.Output(t, terraformOptions, "subscription_id")
				namespace := getEventHubNamespace(t, subscriptionID, resourceGroupName, name)

				assert.Equal(t, name, *namespace.Name)
				assert.Equal(t, testCase.sku, string(namespace.Sku.Name))
				assert.Equal(t, testCase.capacity, int(*namespace.Sku.Capacity))
			})
	}
}
