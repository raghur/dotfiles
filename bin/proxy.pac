function FindProxyForURL(url, host)
{
    // firefox - Ctrl-Shift-J Chrome/Chromium: chrome://net-internals/#events
    var debug = true;
    var skipPattern = /https?:\/\/(192\.168\.99\.)|localhost/;
    var log = function() {
        if (debug) {
            var args = Array.prototype.slice.call(arguments);
            alert(args.join(" "));
        }
    }
    log(url)
    if (url.indexOf("harmanhub.") >= 0) {
        log("work url", url);
        return "PROXY 10.98.2.8:8080";
    }
    if (url.match(skipPattern)) {
        log("matched skip pattern", url);
        return "DIRECT";
    }
    var bypassProxy = false;
    log("Checking for availability of myIpAddressEx:", typeof(myIpAddressEx) == "function");
    // firefox doesn't have myIpAddressEx - but it does seem to return the
    // right IP
    if (typeof(myIpAddressEx) != "function") {
        log("myIpAddress returns: ", myIpAddress());
        bypassProxy = myIpAddress() == '10.8.0.6' || myIpAddress().startsWith("192.168.1.");
    } else {
        // chromium seems to pick the first IP - in my case, a virtualbox HOST
        // only IP. So check in all IPs returned by myIpAddressEx
        var ips = myIpAddressEx().split(";");
        log("myIpAddressEx returns", myIpAddressEx());
        for(i=0; i< ips.length; i++) {
            if (ips[i] == "10.8.0.6" || ips[i].startsWith("192.168.1.")) {
                bypassProxy = true;
                break;
            }
        }
    }
    log("Can bypass proxy: ", bypassProxy);
    if (bypassProxy)
    {
        log ("DIRECT")
        return "DIRECT";
    }
    else
    {
        log( "PROXY")
        return "PROXY 10.98.2.8:8080";
    }
}
