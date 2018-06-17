clean:
	find . -type d -name ".terraform" -exec rm -rv -- "{}" +
	find ./backend -type f -name "terraform.tfstate*" -exec rm -v -- "{}" +
