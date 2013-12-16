<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Site created</title>
</head>
<body>

<h1>Site created.</h1>
<p>
	Setup &amp; push your git repository now using :

	<pre class="code">
		git remote add ec2 ssh://{USER}@<?php echo `curl http://169.254.169.254/latest/meta-data/public-ipv4` ?>{REPO}
		git push ec2 +master:refs/heads/master
	</pre>
</p>
	
</body>
</html>