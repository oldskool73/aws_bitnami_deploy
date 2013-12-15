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

	<span class="code">
		git remote add ec2 ssh://bitnami@<?php echo $_SERVER['SERVER_ADDR'] ?>/home/bitnami/deploy/repo.git
		git push ec2 +master:refs/heads/master
	</span>
</p>
	
</body>
</html>