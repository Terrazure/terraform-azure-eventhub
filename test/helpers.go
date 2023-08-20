package test

import (
	eventhub "github.com/Azure/azure-sdk-for-go/services/preview/eventhub/mgmt/2018-01-01-preview/eventhub"
	helpers "github.com/Terrazure/terratest-helpers"
	"testing"
)

func getEventHubNamespace(t *testing.T, subscriptionID, resourceGroupName, namespaceName string) eventhub.EHNamespace {
	t.Helper()
	client := eventhub.NewNamespacesClient(subscriptionID)
	helpers.ConfigureAzureResourceClient(t, &client.Client)
	ctx, cancel := helpers.BuildDefaultHttpContext()
	defer cancel()
	namespace, err := client.Get(ctx, resourceGroupName, namespaceName)

	if err != nil {
		t.Fatalf("Error while trying to get the namespace %s in %s", namespaceName, resourceGroupName)
	}

	return namespace
}
