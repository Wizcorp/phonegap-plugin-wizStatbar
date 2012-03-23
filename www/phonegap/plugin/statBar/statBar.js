/* StatBar PhoneGap Plugin - JavaScript side of the bridge to StatBarPlugin.java
*
 * @author WizCorp Inc. [ Incorporated Wizards ] 
 * @copyright 2011
 * @file JavaScript StatBarPlugin for PhoneGap
 *
*/



/*-------------------
*
* statBar for PhoneGap
*
* PhoneGap.exec(<<successCallback>>,<<failureCallback>>,<<Plugin Name>>,<<Action Name>>,<<Arguments Array>>);
*
*
--------------------*/

var statBar = { 
	
	
	// send stats
	sendStats: function(a,s,f) {
	 	return PhoneGap.exec(s, f, 'StatBarPlugin', 'sendStats', [a]);	
	},
    
    create: function(a,s,f) {
        return PhoneGap.exec(s, f, 'StatBarPlugin', 'create', [a]);
    },
    
    update: function(e) {
        return PhoneGap.exec(null, null, 'StatBarPlugin', 'update', [e]);
    },
    
    show: function(a,s,f) {
        return PhoneGap.exec(s, f, 'StatBarPlugin', 'show', [a]);
    },
    
    hide: function(a,s,f) {
         return PhoneGap.exec(s, f, 'StatBarPlugin', 'hide', [a]);	
    },
    
    enable: function(s,f) {
        if(typeof(s) == "undefined") { 
			return PhoneGap.exec(null, null, "StatBarPlugin", "enable", []);
		} else {
			return PhoneGap.exec(s, f, "StatBarPlugin", "enable", []);
		}
    },
        
    disable: function(s,f) {
        if(typeof(s) == "undefined") { 
			return PhoneGap.exec(null, null, "StatBarPlugin", "disable", []);
		} else {
			return PhoneGap.exec(s, f, "StatBarPlugin", "disable", []);
		}
    }
	

};