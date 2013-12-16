<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Site created</title>
</head>
<body>

<h1>Site created.</h1>
<p>
	To setup &amp; push your git repository now using ssh :
</p>

<p> First ensure your public key is on the server. Then add a record to your ~/.ssh/config : </p>p>
	<pre class="code">
Host {server-name}
	Hostname <?php echo `curl http://169.254.169.254/latest/meta-data/public-ipv4` ?>
	user {USER}
	IdentityFile {/full/path/to/your/privatekey.pem
	</pre>	

<p> Then add a remot and push with : </p>

	<pre class="code">
git remote add ec2 ssh://{server-name}{REPO}
git push ec2 +master:refs/heads/master
	</pre>
</p>

<p> In the future you can then push to the server with just : </p>

<pre>
git push ec2 {branch}
</pre>
	
</body>
</html>