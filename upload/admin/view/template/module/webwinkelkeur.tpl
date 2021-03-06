<?php echo $header; ?>
<div id="content">
  <div class="page-header">
    <div class="container-fluid">
      <div class="pull-right">
        <button type="submit" form="form" class="btn btn-primary"
                data-toggle="tooltip" title="<?php echo $button_save; ?>" >
          <i class="fa fa-save"></i>
        </button>
        <a href="<?php echo $cancel; ?>" class="btn btn-default"
           data-toggle="tooltip" title="<?php echo $button_cancel; ?>">
          <i class="fa fa-reply"></i>
        </a>
      </div>
      <h1>WebwinkelKeur</h1>
      <ul class="breadcrumb">
        <?php foreach ($breadcrumbs as $breadcrumb) : ?>
        <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
        <?php endforeach; ?>
      </ul>
    </div>
  </div>
  <div class="container-fluid">
    <form action="" method="post" enctype="multipart/form-data" class="form-horizontal" id="form" name="webwinkelkeur">
      <?php if(count($stores) > 1): ?>
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-pencil"></i>Selecteer winkel</h3>
        </div>
        <div class="panel-body">
          <div class="form-group">
            <label class="col-sm-2 control-label">Actieve winkel</label>
            <div class="col-sm-10">
              <input type="hidden" id="redirStore" name="selectStore" />
              <select class="form-control" name="store_id" onchange="switchStore();">
              <?php foreach($stores as $store): ?>
                <option value="<?php echo $store['store_id'] ?>"
                        <?php if($store['store_id'] == $view_stores[0]['settings']['store_id']) echo "selected"; ?> >
                  <?php echo $store['name'] ?>
                </option>
              <?php endforeach; ?>
              </select>
            </div>
          </div>
        </div>
      </div>
      <?php endif ?>
      <?php foreach($view_stores as $store): ?>
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-pencil"></i>Instellingen</h3>
        </div>
        <div class="panel-body">
          <div class="form-group required">
            <label class="col-sm-2 control-label">Webwinkel ID</label>
            <div class="col-sm-10">
              <input type="text" class="form-control" name="store[shop_id]"
                     value="<?php echo $store['settings']['shop_id']; ?>" />
              <?php if($error_shopid): ?>
                <div class="text-danger"><?php echo $error_shopid; ?></div>
              <?php endif; ?>
            </div>
          </div>
          <div class="form-group required">
            <label class="col-sm-2 control-label">API key</label>
            <div class="col-sm-10">
              <input type="text" class="form-control" name="store[api_key]"
                     value="<?php echo $store['settings']['api_key']; ?>" />
              <?php if($error_apikey): ?>
                <div class="text-danger"><?php echo $error_apikey; ?></div>
              <?php endif; ?>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">Sidebar weergeven</label>
            <div class="col-sm-10">
              <label class="radio-inline">
                <input type="radio" value="1" <?php if($store['settings']['sidebar']) echo "checked"; ?>
                       name="store[sidebar]" >
                Ja
              </label>
              <label class="radio-inline">
                <input type="radio" value="0" <?php if(!$store['settings']['sidebar']) echo "checked"; ?>
                       name="store[sidebar]" >
                Nee
              </label>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">Sidebar positie</label>
            <div class="col-sm-10">
              <select class="form-control"
                      name="store[sidebar_position]">
                <option value="left"  <?php if($store['settings']['sidebar_position'] == 'left') echo "selected"; ?> >Links</option>
                <option value="right" <?php if($store['settings']['sidebar_position'] == 'right') echo "selected"; ?> >Rechts</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label required">
              <span data-toggle="tooltip"
                    title="aantal pixels vanaf de bovenkant">
                Sidebar hoogte
              </span>
            </label>
            <div class="col-sm-10">
              <input type="text" size="2" value="<?php echo $store['settings']['sidebar_top']; ?>" class="form-control"
                     name="store[sidebar_top]" />
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">
              <span data-toggle="tooltip"
                    title="alleen beschikbaar voor Plus-leden">
                Uitnodiging versturen
              </span>
            </label>
            <div class="col-sm-10">
              <select class="form-control" name="store[invite]">
                <option value="1" <?php if($store['settings']['invite'] == 1) echo "selected"; ?> >Ja, na elke bestelling</option>
                <option value="2" <?php if($store['settings']['invite'] == 2) echo "selected"; ?> >Ja, alleen bij de eerste bestelling</option>
                <option value="0" <?php if($store['settings']['invite'] == 0) echo "selected"; ?> >Nee, geen uitnodigingen versturen</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">
              <span data-toggle="tooltip"
                    title="de uitnodiging wordt verstuurd nadat het opgegeven aantal dagen is verstreken">
                Wachttijd voor uitnodiging
              </span>
            </label>
            <div class="col-sm-10">
              <input type="text" size="2" class="form-control"
                     value="<?php echo $store['settings']['invite_delay']; ?>"
                     name="store[invite_delay]" />
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">
              <span data-toggle="tooltip"
                    title="de uitnodiging wordt alleen verstuurd wanneer de bestelling de aangevinkte status heeft" >
                Orderstatus voor uitnodiging
              </span>
            </label>
            <div class="col-sm-10">
              <div class="well well-sm" style="height: 150px; overflow: auto;">
                <?php foreach($order_statuses as $order_status): ?>
                  <div class="checkbox webwinkelkeur-order-statuses">
                    <label>
                      <input type="checkbox" name="store[order_statuses][]"
                             value="<?php echo $order_status['order_status_id']; ?>"
                             <?php if(in_array($order_status['order_status_id'], $store['settings']['order_statuses'])) echo 'checked'; ?> />
                        <?php echo $order_status['name']; ?>
                    </label>
                  </div>
                <?php endforeach; ?>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">Tooltip weergeven</label>
            <div class="col-sm-10">
              <label class="radio-inline">
                <input type="radio" value="1" <?php if($store['settings']['tooltip']) echo "checked"; ?>
                       name="store[tooltip]">
                Ja
              </label>
              <label class="radio-inline">
                <input type="radio" value="0" <?php if(!$store['settings']['tooltip']) echo "checked"; ?>
                       name="store[tooltip]">
                Nee
              </label>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">JavaScript-integratie</label>
            <div class="col-sm-10">
              <label class="radio-inline">
                <input type="radio" value="1" <?php if($store['settings']['javascript']) echo "checked"; ?>
                       name="store[javascript]">
                Ja
              </label>
              <label class="radio-inline">
                <input type="radio" value="0" <?php if(!$store['settings']['javascript']) echo "checked"; ?>
                       name="store[javascript]">
                Nee
              </label>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">
              <span data-toggle="tooltip"
                    title="Voeg een <a href='https://support.google.com/webmasters/answer/99170?hl=nl'>rich snippet</a> toe aan de footer. Google kan uw waardering dan in de zoekresultaten tonen. Gebruik op eigen risico.">
                Rich snippet sterren
              </span>
            </label>
            <div class="col-sm-10">
              <label class="radio-inline">
                <input type="radio" value="1"
                       <?php if($store['settings']['rich_snippet']) echo "checked"; ?>
                       name="store[rich_snippet]">
                Ja
              </label>
              <label class="radio-inline">
                <input type="radio" value="0"
                       <?php if(!$store['settings']['rich_snippet']) echo "checked"; ?>
                       name="store[rich_snippet]">
                Nee
              </label>
            </div>
          </div>
        </div>
      </div>
      <?php endforeach; ?>
    </form>
    <?php if($invite_errors): ?>
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-exclamation-triangle"></i>
          Fouten opgetreden bij het versturen van uitnodigingen
        </h3>
      </div>
      <div class="panel-body">
        <table>
          <?php foreach($invite_errors as $invite_error): ?>
          <tr>
            <td style="padding-right:10px;"><?php echo date('d-m-Y H:i', $invite_error['time']); ?></td>
            <td>
              <?php if($invite_error['response']): ?>
              <?php echo htmlentities($invite_error['response'], ENT_QUOTES, 'UTF-8'); ?>
              <?php else: ?>
              De Webwinkelkeur-server kon niet worden bereikt.
              <?php endif; ?>
            </td>
          </tr>
          <?php endforeach; ?>
        </table>
      </div>
    </div>
    <?php endif; ?>
  </div>
</div>
<script>
jQuery(function($) {
    var $container = $('.webwinkelkeur-order-statuses');
    $container.find('label:has(input:checked)').css('font-weight', 'bold');
    $container.find('input').change(function() {
        this.parentNode.style.fontWeight = this.checked ? 'bold' : 'normal';
    });
});
function switchStore() {
  $('#redirStore').val(true);
  $('#form').submit();
}
</script>
<?php echo $footer; ?>
<?php // vim: set sw=2 sts=2 et ft=php :
