# ansible-demo
A demo project for ansible


# Terraform
save a plan
terraform plan -out plans/20180814 > plans/20180814.log

# Vagrant install
if ! type "brew" > /dev/null; then
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)";
fi
brew tap phinze/homebrew-cask && brew install brew-cask;
brew cask install vagrant;
brew cask install virtualbox;

vagrant plugin install vagrant-vbguest