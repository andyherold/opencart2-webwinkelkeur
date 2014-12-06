<?php
require_once DIR_SYSTEM . 'library/Peschar_Ping.php';
class ControllerModuleWebwinkelkeur extends Controller {
    public function index($settings) {
        $this->load->model('module/webwinkelkeur');

        $this->silence(array('Peschar_Ping', 'run'), 'WebwinkelKeur OpenCart', DIR_SYSTEM . '/..');

        if(empty($settings['shop_id']))
            return;

        $data = array();

        if(!empty($settings['sidebar']) || !empty($settings['tooltip'])
           || !empty($settings['javascript'])
        ) {
            $js_settings = array(
                '_webwinkelkeur_id' => (int) $settings['shop_id'],
                '_webwinkelkeur_sidebar' => !empty($settings['sidebar']),
                '_webwinkelkeur_tooltip' => !empty($settings['tooltip']),
            );
            if(!empty($settings['sidebar_position'])) {
                $js_settings['_webwinkelkeur_sidebar_position'] = $settings['sidebar_position'];
            }
            if(!empty($settings['sidebar_top'])) {
                $js_settings['_webwinkelkeur_sidebar_top'] = $settings['sidebar_top'];
            }
            $data['settings'] = $js_settings;
        }

        if(!empty($settings['rich_snippet'])) {
            $html = $this->silence(array($this, 'getRichSnippet'), $settings);
            if($html) $data['rich_snippet'] = $html;
        }

        if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/module/webwinkelkeur.tpl')) {
            $this->template = $this->config->get('config_template') . '/template/module/webwinkelkeur.tpl';
        } else {
            $this->template = 'default/template/module/webwinkelkeur.tpl';
        }

        return $this->load->view($this->template, $data);
    }

    public function cron() {
        $this->load->model('module/webwinkelkeur');
        $this->load->model('extension/module');

        ignore_user_abort(true);

        $modules = $this->model_module_webwinkelkeur->getModulesByCode('webwinkelkeur');
        foreach($modules as $module) {
            $settings = $this->model_extension_module->getModule($module['module_id']);
            $this->model_module_webwinkelkeur->sendInvites($settings);
        }
    }

    private function getRichSnippet($settings) {
        $tmp_dir = @sys_get_temp_dir();
        if(!is_writable($tmp_dir))
            $tmp_dir = '/tmp';
        if(!is_writable($tmp_dir))
            return;

        $url = sprintf('http://www.webwinkelkeur.nl/shop_rich_snippet.php?id=%s',
                       (int) $settings['shop_id']);

        $cache_file = $tmp_dir . DIRECTORY_SEPARATOR . 'WEBWINKELKEUR_'
            . md5(__FILE__) . '_' . md5($url);

        $fp = @fopen($cache_file, 'rb');
        if($fp)
            $stat = @fstat($fp);

        if($fp && $stat && $stat['mtime'] > time() - 7200
           && ($json = stream_get_contents($fp))
        ) {
            $data = json_decode($json, true);
        } else {
            $context = stream_context_create(array(
                'http' => array('timeout' => 3),
            ));
            $json = @file_get_contents($url, false, $context);
            if(!$json) return;

            $data = @json_decode($json, true);
            if(empty($data['result'])) return;

            $new_file = $cache_file . '.' . uniqid();
            if(@file_put_contents($new_file, $json))
                @rename($new_file, $cache_file) or @unlink($new_file);
        }

        if($fp)
            @fclose($fp);
        
        if($data['result'] == 'ok')
            return $data['content'];
    }

    private function silence($method) {
        global $config;
        $args = func_get_args();
        $args = array_slice($args, 1);
        $do = method_exists($config, 'get') && method_exists($config, 'set')
              && ($display = $config->get('config_error_display'));
        if($do)
            $config->set('config_error_display', false);
        $ret = call_user_func_array($method, $args);
        if($do)
            $config->set('config_error_display', $display);
        return $ret;
    }
}
