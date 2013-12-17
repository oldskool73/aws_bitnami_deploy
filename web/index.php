<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Site created</title>

	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">

</head>
<body>

<div class="container">
	<div class="jumbotron">
		<h1>Site created.</h1>
	</div>

	<h2>
		You should now deploy your git repository using ssh
	</h2>

	<h3>1.</h3>
	<p> First ensure your (and anyone else who needs push access) public key is placed on the server. </p>
	<pre class="code">
$ cat ~/.ssh/id_rsa.pub | ssh -i /path/to/aws/keypair.pem bitnami@remoteserver.com "cat - >> .ssh/authorized_keys"
	</pre>

	<h3>2.</h3>
	<p>Then add a record to your ~/.ssh/config (optional, but recommended): </p>

	<pre class="code">
Host {server-name}
	Hostname <?php echo `curl http://169.254.169.254/latest/meta-data/public-ipv4`; echo "\n"?>
	user {USER}
	</pre>	

	<h3>3.</h3>
	<p> Then add a remote and push with : </p>

	<pre class="code">
$ git remote add ec2 ssh://{server-name}{REPO}
$ git push ec2 +master:refs/heads/master
	</pre>

	<h3>4.</h3>
	<p> In the future you can then push new code to the server with just : </p>
	<pre>
	git push ec2 {branch}
	</pre>
</div>

</body>
</html>