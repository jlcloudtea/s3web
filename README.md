# S3 Static Website Setup Script (AWS Academy Learner Lab)

This project provides a simple Bash script (`page.sh`) that creates a temporary static website
in Amazon S3 using the **AWS CLI**.  
It is designed to run inside **AWS Academy Learner Lab** (or any environment with AWS CLI configured).

## What the Script Does

- Prompts you for:
  - Your name
  - Your favourite animal
- Creates a random S3 bucket (prefixed with `tafesa`).
- Generates an `index.html` page using your inputs.
- Configures the S3 bucket for static website hosting.
- Uploads `index.html` and makes it publicly accessible.
- Displays the website URL.
- **Automatically deletes** the bucket and its contents after **10 minutes**.

## Prerequisites (not needed if you enable AWS Academy Learner Lab)

- **AWS CLI** must be installed and configured with a region:
  ```bash
  aws configure

## How to Run (One-Liner)

Just copy and paste this into your Learner Lab terminal:

```bash
bash <(wget -qO- https://tinyurl.com/cld401acf)
