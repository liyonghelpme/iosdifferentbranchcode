//
//  MyPlugins.cpp
//  nozomi
//
//  Created by  stc on 13-6-24.
//
//

#include "MyPlugins.h"
#include "PluginManager.h"
#include "support/CCNotificationCenter.h"
#include "support/user_default/CCUserDefault.h"
#include <string>

using namespace std;
using namespace cocos2d::plugin;
using namespace cocos2d;

MyPlugins* MyPlugins::s_pPlugins = NULL;

MyPlugins::MyPlugins()
: m_pRetListener(NULL)
, m_pIAPPlugin(NULL)
, m_pSharePlugin(NULL)
, m_pIAPListener(NULL)
, m_pAds(NULL)
{
    
}

MyPlugins::~MyPlugins()
{
	unloadPlugins();
	CC_SAFE_DELETE(m_pRetListener);
}

MyPlugins* MyPlugins::getInstance()
{
	if (s_pPlugins == NULL) {
		s_pPlugins = new MyPlugins();
	}
	return s_pPlugins;
}

void MyPlugins::destroyInstance()
{
	CC_SAFE_DELETE (s_pPlugins);
	PluginManager::end();
}

void MyPlugins::loadPlugins(CCDictionary* dict)
{
	m_pPluginNames = CCArray::create();
	m_pPluginNames->retain();
	CCDictionary* pluginSetting;
	pluginSetting = (CCDictionary*) dict->objectForKey("social");
	if(pluginSetting!=NULL){
		m_pSharePlugin = dynamic_cast<ProtocolSocial*>(PluginManager::getInstance()->loadPlugin(pluginSetting->valueForKey("name")->getCString()));
		if (NULL != m_pSharePlugin)
		{
			m_pPluginNames->addObject(CCString::create(pluginSetting->valueForKey("name")->getCString()));

			TSocialDeveloperInfo pSocialInfo;
			CCDictionary* configDict = (CCDictionary*) pluginSetting->objectForKey("config");
			CCArray* configKeys = configDict->allKeys();
			CCObject* configKey;
			CCARRAY_FOREACH(configKeys, configKey)
			{
				const char* keyStr = ((CCString*)configKey)->getCString();
				pSocialInfo[keyStr] = configDict->valueForKey(keyStr)->getCString();
			}
			m_pSharePlugin->setDebugMode(false);
			m_pSharePlugin->configDeveloperInfo(pSocialInfo);
			if (m_pRetListener == NULL)
			{
				m_pRetListener = new MyShareResult();
			}
			m_pSharePlugin->setResultListener(m_pRetListener);
		}
	}
	pluginSetting = (CCDictionary*) dict->objectForKey("iap");
	if(pluginSetting!=NULL){
		m_pIAPPlugin = dynamic_cast<ProtocolIAP*>(PluginManager::getInstance()->loadPlugin(pluginSetting->valueForKey("name")->getCString()));
		if (NULL != m_pIAPPlugin)
		{
			m_pPluginNames->addObject(CCString::create(pluginSetting->valueForKey("name")->getCString()));

			TIAPDeveloperInfo pIAPInfo;
			CCDictionary* configDict = (CCDictionary*) pluginSetting->objectForKey("config");
			CCArray* configKeys = configDict->allKeys();
			CCObject* configKey;
			CCARRAY_FOREACH(configKeys, configKey)
			{
				const char* keyStr = ((CCString*)configKey)->getCString();
				pIAPInfo[keyStr] = configDict->valueForKey(keyStr)->getCString();
			}
			m_pIAPPlugin->setDebugMode(true);
			m_pIAPPlugin->configDeveloperInfo(pIAPInfo);
			if (m_pIAPListener == NULL)
			{
				m_pIAPListener = new MyPayResult();
			}
			m_pIAPPlugin->setResultListener(m_pIAPListener);
		}
	}
	pluginSetting = (CCDictionary*)dict->objectForKey("ads");
	if(pluginSetting!=NULL){
		m_pAds = dynamic_cast<ProtocolAds*>(PluginManager::getInstance()->loadPlugin(pluginSetting->valueForKey("name")->getCString()));
		if(m_pAds){
			m_pPluginNames->addObject(CCString::create(pluginSetting->valueForKey("name")->getCString()));
		}
	}
}

void MyPlugins::unloadPlugins()
{
	m_pSharePlugin = NULL;
	m_pIAPPlugin = NULL;
	m_pAds = NULL;
	CCObject* pluginName;
	CCARRAY_FOREACH(m_pPluginNames, pluginName)
	{
		PluginManager::getInstance()->unloadPlugin(((CCString*)pluginName)->getCString());
	}
	CC_SAFE_RELEASE_NULL(m_pPluginNames);

}

void MyPlugins::share(const char* sharedText, const char* sharedImagePath)
{
    TShareInfo info;
    info["SharedText"] = sharedText;
    if(sharedImagePath!=NULL)
        info["SharedImagePath"] = sharedImagePath;
	if(m_pSharePlugin!=NULL)
	    m_pSharePlugin->share(info);
}

void MyPlugins::pay(const char* productId)
{
	TProductInfo info;
	info["productName"] = productId;
	char uid[20] = {};
	sprintf(uid, "%d", CCUserDefault::sharedUserDefault()->getIntegerForKey("userId"));
	info["payerId"] = std::string(uid);
	if(m_pIAPPlugin!=NULL)
		m_pIAPPlugin->payForProduct(info);
}

void MyPlugins::sendCmd(const char *cmd, const char *args) {
	if(m_pAds != NULL) {  
		string c(cmd);   
		if(c == "showAds") {  
			m_pAds->showAds((ProtocolAds::AdsType)0, 0, (ProtocolAds::AdsPos)0);  
		} else if(c == "hideAds") {  
			m_pAds->hideAds((ProtocolAds::AdsType)0); 
		} else if(c == "moregames") {  
            m_pAds->spendPoints(0);  
		} else if(c == "hideMoreGames") {  
			m_pAds->spendPoints(1); 
		} else if(c == "showOffers") {
            m_pAds->spendPoints(2);
        } else if(c == "hideOffers") {
            m_pAds->spendPoints(3);
        } else if(c == "setUid") {
            TAdsDeveloperInfo info;
            info["uid"] = args;
            m_pAds->configDeveloperInfo(info);
        }
	}  
}

void MyShareResult::onShareResult(ShareResultCode ret, const char* msg)
{
    if(ret == kShareSuccess){
        CCNotificationCenter::sharedNotificationCenter()->postNotification("EVENT_SHARE_SUCCESS");
    }
    else{
        CCNotificationCenter::sharedNotificationCenter()->postNotification("EVENT_SHARE_FAIL");
    }
}

void MyPayResult::onPayResult(PayResultCode ret, const char* msg, TProductInfo info)
{
    if(ret == kPaySuccess){
        CCNotificationCenter::sharedNotificationCenter()->postNotification("EVENT_BUY_SUCCESS");
    }
    else{
        CCNotificationCenter::sharedNotificationCenter()->postNotification("EVENT_BUY_FAIL");
    }
}
