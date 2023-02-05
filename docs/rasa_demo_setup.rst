****************
Rasa Demo Setup
****************
Now in order to test everything we need a demo app to deploy, you can use whatever you like but for our setup we are using a Rasa chatbot on a github pages setup.

Everything being performed in this step will be done in the ``rasa`` directory.

Deploy Rasa On Kubernetes
-------------------------
So now we want to deploy our previous chatbot model from our last video we made, so in order to do that we setup a helm chart values file to use.

First thing we need to do is add our helm repos::

    helm repo add rasa https://helm.rasa.com
    helm repo update

Now we can actually install our Rasa chatbot using the helm install with our values file ``rasa.values.yaml``.

There are a few custom things that need to be set in this file however::

    hostname - This needs to be set to whatever your a record you setup in dns was with your custom domain.
    hosts - The hosts section under secret needs to be set to the same name as the hostname.
    initialModel - This should be pointing to a non authenticated location where your rasa model is,
                   we are using the model from a previous video we made with a chatbot.


Now that we have set our values we can install this into kubernetes::

    helm install -f rasa-values.yaml rasa rasa/rasa

This might take a few mins to come up, but once the pod shows ready you can see the status via going to https://subdomain.yourdomain.com/status

You can check the pod status by running::

    kubectl get pods

And you should see these::

    NAME                                                READY   STATUS              RESTARTS   AGE
    rasa-6fb894b7c-vr85l                                0/1     PodInitializing     0          36s
    rasa-postgresql-0                                   0/1     ContainerCreating   0          35s

Once these show running you should be able to hit the resource at the https://subdomain.yourdomain.com/status route.

You can also add this to your existing github pages ``index.html`` file by adding this in::

    <div
        id="rasa-chat-widget"
        data-avatar-background="rgba(255, 255, 255, 0)"
        data-avatar-url="https://avatars.githubusercontent.com/u/115162917?s=200&v=4"
        data-root-element-id="storybook-preview-wrapper"
        data-websocket-url="https://rasa.devopswithbrian.com/"
        id="rasa-chat-widget"
    ></div>

    <script src="https://unpkg.com/@rasahq/rasa-chat" type="application/javascript"></script>