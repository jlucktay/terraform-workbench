provider "google" {
  credentials = "${file("james-lucktaylor-terraform-c16716b7d619.json")}"
  project     = "james-lucktaylor-terraform"
  region      = "europe-west1"                                            # Belgium
}
