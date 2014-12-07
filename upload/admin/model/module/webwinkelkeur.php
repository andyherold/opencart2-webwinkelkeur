<?php
class ModelModuleWebwinkelkeur extends Model {
    public function install() {
        if(!in_array('webwinkelkeur_invite_sent', $this->getColumnNames('order'))) {
            $this->db->query("
                ALTER TABLE `" . DB_PREFIX . "order`
                ADD COLUMN webwinkelkeur_invite_sent BOOLEAN NOT NULL DEFAULT 0
            ");
        }

        if(!in_array('webwinkelkeur_invite_tries', $this->getColumnNames('order'))) {
            $this->db->query("
                ALTER TABLE `" . DB_PREFIX . "order`
                ADD COLUMN webwinkelkeur_invite_tries INT NOT NULL DEFAULT 0
            ");
        }

        if(!in_array('webwinkelkeur_invite_time', $this->getColumnNames('order'))) {
            $this->db->query("
                ALTER TABLE `" . DB_PREFIX . "order`
                ADD COLUMN webwinkelkeur_invite_time INT NOT NULL DEFAULT 0
            ");
        }

        $this->db->query("UPDATE `" . DB_PREFIX . "order` SET webwinkelkeur_invite_sent = 1");

        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "webwinkelkeur_invite_error`");

        $this->db->query("
            CREATE TABLE `" . DB_PREFIX . "webwinkelkeur_invite_error` (
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                url VARCHAR(255) NOT NULL,
                response TEXT NOT NULL,
                time BIGINT NOT NULL,
                INDEX time (time)
            ) ENGINE=MyISAM DEFAULT CHARSET=utf8
        ");
    }

    public function uninstall() {
        if(in_array('webwinkelkeur_invite_sent', $this->getColumnNames('order'))) {
            $this->db->query("ALTER TABLE `" . DB_PREFIX . "order` DROP COLUMN webwinkelkeur_invite_sent");
        }

        if(in_array('webwinkelkeur_invite_tries', $this->getColumnNames('order'))) {
            $this->db->query("ALTER TABLE `" . DB_PREFIX . "order` DROP COLUMN webwinkelkeur_invite_tries");
        }

        if(in_array('webwinkelkeur_invite_time', $this->getColumnNames('order'))) {
            $this->db->query("ALTER TABLE `" . DB_PREFIX . "order` DROP COLUMN webwinkelkeur_invite_time");
        }

        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "webwinkelkeur_invite_error`");
    }

    public function getColumnNames($table) {
        $query = $this->db->query("DESCRIBE `" . DB_PREFIX . $table . "`");

        $column_names = array();

        foreach($query->rows as $column)
            $column_names[] = $column['Field'];

        return $column_names;
    }

    public function getInviteErrors() {
        $until = time() - 86400 * 3;
        $query = $this->db->query("
            SELECT *
            FROM `" . DB_PREFIX . "webwinkelkeur_invite_error`
            WHERE time > $until
            ORDER BY time
        ");
        return $query->rows;
    }

    public function getStores() {
        $query = $this->db->query("
            SELECT
                store_id, value as name
            FROM
                `". DB_PREFIX . "setting`
            WHERE `key` = 'config_name'
        ");
        return $query->rows;
    }
}
