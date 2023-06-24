package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

type EventHubtBasicTestCase struct {
	capacity        int64
	sku             string
	isZoneRedundant bool
}

func TestBasicConfiguration(t *testing.T) {
	t.Parallel()

	testCases := []EventHubtBasicTestCase{
		{isZoneRedundant: false, sku: "Basic", capacity: 6},
		{isZoneRedundant: true, sku: "Standard", capacity: 1},
	}

	for _, testCase := range testCases {
		subTestName := fmt.Sprintf("%s-sku-%v-capacity",
			testCase.sku,
			testCase.capacity)

		t.Run(subTestName, func(t *testing.T) {
			testCase := testCase
			t.Parallel()

			terraformOptions := &terraform.Options{
				TerraformDir: "./basic",
				Vars: map[string]interface{}{
					"capacity":       testCase.capacity,
					"zone_redundant": testCase.isZoneRedundant,
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
			assert.Equal(t, testCase.isZoneRedundant, *namespace.ZoneRedundant)
			assert.Equal(t, testCase.capacity, int(*namespace.Sku.Capacity))
		})
	}
}
