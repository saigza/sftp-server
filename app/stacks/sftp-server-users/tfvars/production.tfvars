sftp_user_s3_bucket_name = <%= output('sftp-server.s3_bucket_name') %>
sftp_user_role_read_arn  = <%= output('sftp-server.transfer_server_role_read_arn') %>
sftp_user_role_write_arn = <%= output('sftp-server.transfer_server_role_write_arn') %>

sftp_users = {
    "fsanchez"={
        read_only = true,
        user_home = "MiguelAngel/Lisa"
    },
    "isantiago"={
        read_only = true,
        user_home = "MiguelAngel/Lisa"
    },
    "sgomez"={
        read_only = true,
        user_home = "MiguelAngel/Lisa"
    }
}
<% depends_on('sftp-server') %>
