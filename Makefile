clean:
	find . -type d -name ".terraform" -exec rm -rv -- "{}" +
	find . -type f -iname "*.zip" -exec rm -v -- "{}" +
	find ./backend -type f -name "terraform.tfstate*" -exec rm -v -- "{}" +
