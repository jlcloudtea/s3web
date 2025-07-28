#!/bin/bash

set -e

read -p "What is your name? " name
read -p "What is your favorite animal? " animal

random_number=$(shuf -i 10000-99999 -n 1)
bucket="tafesa$random_number"
animal_lower=$(echo "$animal" | tr '[:upper:]' '[:lower:]')

# Create index.html
cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Welcome $name!</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background: linear-gradient(to right, #74ebd5, #9face6);
      text-align: center;
      padding: 50px;
    }
    h1 {
      color: #2e3d60;
      font-size: 3em;
    }
    .fun-fact {
      margin-top: 40px;
      font-weight: bold;
      background-color: #fff;
      padding: 15px;
      border-radius: 10px;
      display: inline-block;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
  </style>
</head>
<body>
  <h1>Hi, $name! 🐾</h1>
  <p>Your favorite animal is <strong>$animal</strong>.</p>
  <div class="fun-fact" id="factBox">
    Click the button to see a fun fact about $animal!
  </div><br><br>
  <button onclick="showFact()">Show Fun Fact</button>
  <script>
    const facts = {
      "cat": ["Cats sleep 70% of their lives.", "A group of cats is called a clowder."],
      "dog": ["Dogs can understand over 250 words.", "Dogs have 300 million smell receptors."],
      "$animal_lower": ["$animal is awesome!", "You picked a great animal!"]
    };
    function showFact() {
      const animal = "$animal_lower";
      const factList = facts[animal] || facts["$animal_lower"];
      const fact = factList[Math.floor(Math.random() * factList.length)];
      document.getElementById("factBox").innerText = fact;
    }
  </script>
</body>
</html>
EOF

echo "Creating bucket: $bucket"
aws s3 mb s3://$bucket

echo "Disabling Block Public Access on bucket $bucket"
aws s3api delete-public-access-block --bucket $bucket

echo "Setting bucket policy for public read access"
cat > bucket-policy.json <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicReadGetObject",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::$bucket/*"
  }]
}
POLICY

aws s3api put-bucket-policy --bucket $bucket --policy file://bucket-policy.json

echo "Enabling website hosting"
aws s3 website s3://$bucket/ --index-document index.html

echo "Uploading index.html to S3 without ACLs"
aws s3 cp index.html s3://$bucket/index.html

region=$(aws configure get region)

echo ""
echo "Your website is live at:"
echo "http://$bucket.s3-website-$region.amazonaws.com"
