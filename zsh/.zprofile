export XDG_RUNTIME_DIR="/run/user/$UID"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"
