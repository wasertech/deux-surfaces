set -e

# Check Termux version
if [ ! -f $PREFIX/bin/termux-info ]; then
    echo "Termux is not installed."
    return 1
fi

# Update Termux packages
pkg update -y

# Install dependencies
pkg install -y proot proot-distro git which

# Install selected Linux distribution

echo "Select a Linux distribution to install:"
proot-distro list

echo "Enter the alias of the Linux distribution to install..."
echo "Default: manjaro"
echo "Just hit enter if this option sounds appealing."

read -p '❯  ' DUO_DISTRO

if [ -z $DUO_DISTRO ]; then
    DUO_DISTRO='manjaro'
fi

proot-distro install $DUO_DISTRO || true

# Clone deux.sh from GitHub

# Install deux.sh in $PREFIX/bin
mkdir -p $PREFIX/bin
tmpdir=$(mktemp -d XXXXXX)
duodir=${tmpdir}/deux-surfaces
git clone https://github.com/wasertech/deux-surfaces.git ${duodir}
rm -rf ${PREFIX}/bin/deux.sh && \
rm -rf ${PREFIX}/bin/deux.zsh && \
cp ${duodir}/deux.sh ${PREFIX}/bin/deux.sh && \
cp ${duodir}/deux.zsh ${PREFIX}/bin/deux.zsh && \
rm -rf ${tmpdir} || echo "Couldn't install deux."

# Make deux.sh executable
chmod +x $PREFIX/bin/deux.sh

# Make sure Temrmux's default user's .bashrc exists
if [ ! -f $HOME/.bashrc ]; then
    touch $HOME/.bashrc
fi

# # Make sure DUO root's .bashrc exists.
# if [ ! -f /root/.bashrc ]; then
#     touch /root/.bashrc
# fi

# # Check if 'deux.sh' is configured in root's .bashrc
# if ! grep -q "deux.sh" /root/.bashrc; then
#     echo "source $PREFIX/bin/deux.sh" >> /root/.bashrc
# fi

# Check if DUO_DISTRO is set in .bashrc

if grep -q "DUO_DISTRO" $HOME/.bashrc; then
    echo "DUO_DISTRO is already set in .bashrc."
fi

# Set DUO_DISTRO in .bashrc

if ! grep -q "DUO_DISTRO" $HOME/.bashrc; then
    echo "export DUO_DISTRO='${DUO_DISTRO}'" >> $HOME/.bashrc
fi

# Check if deux.sh is already sourced in .bashrc

if grep -q "deux.sh" $HOME/.bashrc; then
    echo "deux.sh is already sourced in .bashrc."
fi

# Source deux.sh in .bashrc

if ! grep -q "deux.sh" $HOME/.bashrc; then
    echo "source $PREFIX/bin/deux.sh" >> $HOME/.bashrc
fi

# # Make sure .zshrc exists
# if [ ! -f /root/.zshrc ]; then
#     touch /root/.zshrc
# fi

# if grep -q "deux.zsh" /root/.zshrc; then
#     echo "deux.zsh is already sourced in .zshrc."
# fi

# Source deux.zsh in .zshrc

# if ! grep -q "deux.zsh" /root/.zshrc; then
#     echo "source $PREFIX/bin/deux.zsh" >> /root/.zshrc
# fi

echo "Deux has been installed successfully."
echo "Type bash or restart Termux to start using it."
