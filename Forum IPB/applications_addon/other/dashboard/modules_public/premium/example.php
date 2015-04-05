<?php
$config_homepay=array();

// KONFIGURACJA
// Numer ID u¿ytkownika HOMEPAY
$config_homepay_usr_id=2;
// ACCID oznacza numer konta SMS KOD w homepay
// NETTO i BRUTTO to odpowiednio wartosc netto i brutto smsa, NAZWA to nazwa uslugi, a NUMER to numer premium sms, TEKST oznacza tekst smsa
// kolejne uslugi nalezy dopisywac wg schematu:
// $config_homepay[ACCID]=array("acc_id"=>ACCID, "nazwa"=>NAZWA,"netto"=>NETTO,"brutto"=>BRUTTO,"number"=>"NUMER","text"=>TEKST)
$config_homepay[]=array("acc_id"=>2419,"nazwa"=>"TEST","netto"=>0.50,"brutto"=>0.61,"numer"=>"7055","tekst"=>"HPAY.TEST");
$config_homepay[]=array("acc_id"=>2420,"nazwa"=>"TEST2","netto"=>1,"brutto"=>1.23,"numer"=>"7155","tekst"=>"HPAY.TEST");
// KONIEC KONFIGURACJI

if($_POST&&$_POST['check_code'])
    {
    $code=$_POST['code'];
    if(!preg_match("/^[A-Za-z0-9]{8}$/",$code)) echo "Zly format kodu - 8 znakow.";
    elseif(empty($config_homepay[$_POST['usluga']])) echo "Brak takiej uslugi.";
    else
	{
	$handle=fopen("http://homepay.pl/API/check_code.php?usr_id=".$config_homepay_usr_id."&acc_id=".$config_homepay[$_POST['usluga']]['acc_id']."&code=".$code,'r');
	$check=fgets($handle,8);
	fclose($handle);
	if($check=="1")
	    {
	    echo "Gratulacje, kod poprawny. Kupiles cos w usludze ".$config_homepay[$_POST['usluga']]['nazwa'];
	    }
	elseif($check=="0")
	    {
	    echo "Nieprawidlowy kod.";
	    }
	else
	    {
	    echo "Blad w polaczeniu z operatorem.";
	    }
    
	}
    }
    
?>
<html><body>
<br/><br/>
<?php
foreach($config_homepay as $v)
echo "Wyslij SMS o tresci ".$v['tekst']." na numer ".$v['numer']." za ".$v['netto']."zl + VAT ( ".$v['brutto']."zl )<br/>\n";
?>
<br/><br/>
<form method="post" action="">
<input type="hidden" name="check_code" value="1">
Podaj kod: <input type="text" size="8" name="code"> do uslugi: <select name="usluga">
<?php
foreach($config_homepay as $k=>$v) 
echo "<option name=\"usluga\" value=\"$k\">".$v['nazwa']."</option>\n";
?>
</select>
<br/>
<input type="submit" value="Sprawdz">
</form>
</body>
</html>