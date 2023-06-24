package test

import (
	"context"
	eventhub "github.com/Azure/azure-sdk-for-go/services/preview/eventhub/mgmt/2018-01-01-preview/eventhub"
	"testing"
	"time"
)

func BuildDefaultHttpContext() (context.Context, context.CancelFunc) {
	return context.WithTimeout(context.Background(), 10*time.Minute)
}

func getEventHubNamespace(t *testing.T, subscriptionID, resourceGroupName, namespaceName string) eventhub.EHNamespace {
	t.Helper()
	client := eventhub.NewNamespacesClient(subscriptionID)
	ctx, cancel := BuildDefaultHttpContext()
	defer cancel()
	namespace, err := client.Get(ctx, resourceGroupName, namespaceName)

	if err != nil {
		t.Fatalf("Error while trying to get the namespace %s in %s", namespaceName, resourceGroupName)
	}

	return namespace
}
