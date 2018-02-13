terraform {
  backend "swift" {
    container = "hashicorp_blog_post_dev"
  }
}
