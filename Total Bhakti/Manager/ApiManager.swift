
//  Total Bhakti
//
//  Created by Prashant on 08/01/18.
//  Copyright © 2018 MAC MINI. All rights reserved.
//

import UIKit

class APIManager : NSObject {
    class var sharedInstance : APIManager {
        struct Static {
            static let instance = APIManager()
        }
        return Static.instance
    }
    //"http://dev.appsquadz.com/sanskar/index.php/data_model/"
    // let KBASEURL                 = "http://ec2-13-127-166-4.ap-south-1.compute.amazonaws.com/index.php/data_model/"
    // let KBASEURL                 = "http://164.52.192.251/totalbhakti/index.php/data_model/"
   //"http://164.52.192.251/index.php/data_model/"
    
    // http://192.168.0.165/sanskar/index.php/data_model/  dev
    // http://192.168.0.165/total/index.php/data_model/  dev
    
    // http://dev.appsquadz.com/total/index.php/data_model/bhajan/bhajan/get_bhajan_list
    
    //http://164.52.192.251/totalbhakti/index.php/
    
    //"http://164.52.192.251/sanskar/index.php/data_model/" // live
    
    // /let HOMEDATAAPi = Video_control/home_page_videos // this one changed during indexing by sunil
    
    //http://app.sanskargroup.in/sanskar/index.php/auth_panel/login/index  // new live server
    //http://164.52.192.251/sanskar_staging/index.php/data_model/videos/Video_control/like_channel
    //http://app.sanskargroup.in/sanskar/index.php/data_model/ // live
    
   // http://app.sanskargroup.in/sanskar/index.php/data_model/version/Version/get_version


    
    let KHTTPSUCCESS             = 200
    let KBASEURL                 = "https://app.sanskargroup.in/sanskar_development/data_model/" //Stagging
   // let KBASEURL                 = "https://app.sanskargroup.in/data_model/" //LIVE URL
//        let KBASEURL                 = "https://dev.sanskargroup.in/data_model/" //Stagging
//    let KLOGINAPI                = "user/registration/login_authentication"
    let KLOGINAPI                = "user/Registration/login_authentication"
    let KGUESTLOGINAPI           = "user/Registration/guest_login"
    
//    let KOTPAPI                  = "user/registration/otp_verification"
    let KOTPAPI                  = "user/Registration/send_verification_otp"
    let KResendOTPAPI            = "user/Registration/resend_verification_otp"
    let KGETUSERTOKENAPI         = "user/Registration/get_user_profile_with_token"

    let KUPDATEUSER              = "user/registration/update_profile"
    let HOMEDATAAPi              = "videos"
    let KGETVIDEOS               = "videos/Video_control/get_videos"
    let KVIDEOSAPI               = "videos/video_control/search_videos"
    let GURUAPI                  = "guru/guru/get_guru_list"
    let KFOLLOWGURU              = "guru/guru/follow_guru"
    let KUNFOLLWGURUR            = "guru/guru/unfollow_guru"
    let KLIKEGURU                = "guru/guru/like_guru"
    let KUNLIKEGURU              = "guru/guru/unlike_guru"
    let KNEWSAPI                 = "news/news/get_news_list"
    let KBHAJANAPI               = "bhajan/bhajan/get_bhajan_list"
    let KVIDEOLIKEAPI            = "videos/video_control/like_video"
    let KVIDEODISLIKEAPI         = "videos/video_control/unlike_video"
    let KRECENTVIEWAPI           = "videos/video_control/recent_views"
    let KRELATEDVIDEOGURUAPI     = "videos/video_control/get_related_guru_videos"
    let KRELATEDVIDEOINVIDEOAPI  = "videos/video_control/get_related_videos"
    let kAllTVCHANNELAPI         = "videos/Video_control/Channel"
    let KALLVIDEOAPI             = "videos/Video_control/home_page_view_all_videos"
    let KGURURELETEDAUDIOAPI     = "bhajan/bhajan/get_related_guru_audios"
    let KNEWSVIEWS               = "news/news/view_news"
    let KADDCOMMENT              = "videos/Video_control/add_comment"
    let KVIEWCOMMENT             = "videos/Video_control/get_video_comment"
    let KSANKITRAN               = "videos/Video_control/sankirtan_home"
    let KSANKITRANVIEWALL        = "videos/Video_control/view_all_sankirtan_by_category"
    let KBHAJANLIKES             = "bhajan/bhajan/like_bhajan"
    let KBHAJANDISLIKE           = "bhajan/bhajan/unlike_bhajan"
    let KARTISALBUMAPI           = "bhajan/bhajan/get_bhajan_of_artist"
    let get_bhajanBy_god         = "bhajan/bhajan/get_bhajan_of_god"
    let KBhajanSearchApi         = "bhajan/bhajan/search_bhajan"
    let KNOTIFICATIONAPI         = "Notification/get_notification_list"
    let KGETNOTIFICATIONDETAIL   = "Notification/get_notification_detail"
    let view_notification        = "Notification/view_notification"
    let notification_mute        = "user/Registration/change_notification_status"
    let KGRURSEARCHAPI           = "guru/guru/search_guru"
    let KSANKITRANSEARCHAPI      = "videos/video_control/search_sankirtan"
    let KHOMESEARCHAPI           = "videos/Video_control/search_home_data"
    let KRELATEDBHAJNAPI         = "videos/Video_control/get_related_bhajan"
    
    let chat_report              = "chat/Chat/reported_chat"
    let delete_chat_report       = "chat/Chat/delete_reported_chat"
    let clear_notification       = "Notification/clear_notification_history"
    let get_version              = "version/Version/get_version"
    let get_video_meta_data      = "videos/Video_control/get_video_meta_data"
    let get_bhajan_meta_data     = "bhajan/Bhajan/get_bhajan_meta_data"
    let KCategoryAPI             = "menu_master/get_menu_master"
//    let KCategoryAPI             = "menu_master/get_menu_master_v2"
//    let KPremiumListAPI          = "videos/premium_video/get_category_landing_data"
    let KPremiumListAPI          = "videos/Premium_video/get_premium_landing_data"
    let tvGuide                  = "tv-guide"
    let kVideoTime               = "data_model/country_wise_user_video_play_history"

    let KImgThumbnailAPI         = "guru/guru/get_guru_thumbnails"
    let KVideoListByID           = "videos/video_control/get_video_list_by_menu_master"
    let KBhajanListByID          = "bhajan/bhajan/get_bhajan_list_by_menu_master"

    let KLOGOUTAPI               = "user/Registration/logout"
//    let KPREMIUMAPI              = "videos/Premium_video/get_premium_landing_data"
    let KPREMIUMAPI              = "videos/Premium_video/get_category_landing_data"
    let KMENUMASTERSEASONLIST    = "videos/premium_video/get_seasons_list_by_menu_master"
    let KEpisodeBySeasonId       = "videos/premium_video/get_episodes_list_by_season_id"    
    let KPaymentPlanApi          = "videos/premium_video/get_premium_plan"
    let KInitializePaymentApi    = "transaction/initialize_transaction"
    let KPaymentSuccessApi       = "transaction/complete_transaction"
    
//    api for search page
//     mark :- Avi tyagi
    let KSerachApi                = "user/Master_search/centralSearch"
    let Kshortvideo               = "Shorts_video/get_shorts_video"
    let KLivepoojaapi            = "virtual/Virtual_pooja/get_all_virtul_pooja_list"
    let KLivetempleapi           = "virtual/Virtual_pooja/get_thumbnail_list"
    let KLivepoojagodlist        = "virtual/Virtual_pooja/get_god_list"
    let Klivepoojagodwise        = "virtual/Virtual_pooja/get_temple_list"
    let KuserRecord              = "user/User_meta/get_detail_by_device_id"
    let KContinuewatchingpremium = "android_tv/video_control/continue_watching"
    let Kmorelikethisapi         = "videos/premium_video/get_seasons_by_category"
    let Kholiprogramdetailapi    = "Festival_User/Festival_user/get_festival_program_detail"
    let Kholigurudetailapi       = "Festival_User/Festival_user/get_festival_guru"
    let Kcheckpaymentstatusapi   = "videos/premium_video/get_plan_method"
    let kshortsshareapi          = "Shorts_video/get_shorts_video_to_share"
    let Kshortslikeapi           = "Like_dislike_content/add_like_content_by_user"
    let Kshortscommentapi        = "Like_dislike_content/get_all_comment_list"
    let Kshortsusercommentapi    = "Like_dislike_content/users_comment"
    
    let KAdvertiseAPI            = "advertisement/get_advertisement"
    let KAdvertiseDurationAPI    = "advertisement/gap_duration"
    let KCouponListApi           = "coupon/get_coupon"
    let KContinueWatchingAPI     = "videos/video_control/continue_watching"
    let Ksuggestvideo            = "videos/video_control/get_suggestion_by_video_master"
    let KSeasonBYCategory        = "videos/premium_video/get_seasons_by_category"
    let KSocialHidden            = "social_login/get_social_login_status"
    let KUniversalLinkApi        = "videos/video_control/get_data_by_media_id"
    let KBhajanCount             = "bhajan/bhajan/update_bhajan_play_count"
    let KAddRemovePlaylist       = "videos/video_control/playlist"
    let KGetPlaylist             = "videos/video_control/get_playlist"
    let KPromoCodeValidate       = "promocode/validate_promocode"
    let KAds                     = "advertisement/get_app_advertisement"
    let KUpdateLiveUsers         = "live_users/update_live_users"
    let KGetLiveUserCount        = "live_users/get_channel_live_users"
    let kupdateAdCounter         = "advertisement/update_app_advertisement_counter"
    let playTime                 = "country_wise_user_video_play_history"
    let playPop                  = "user/user_meta/get_subscription_url"
    
    // mark Avi tyagi
    let Kmanageapi               = "user/Login_record/get_login_device_record"
    let ktvlogin                 = "user/Registration/sendAndroidTvPushLogin"
    let Kmanagelogoutapi         = "user/Login_record/device_logout"
    let Kprofilelist             = "Loginauthentication/get_all_user_profile"
    let Kaddprofile              = "Loginauthentication/addUserProfile"
    let Keditprofile             = "Loginauthentication/updateUserProfile"
    let Ksearchvideo             = "videos/video_control/get_videos_by_id"
    let Kpaymentjuspayapi        = "https://app.sanskargroup.in/api_doc/PaymentJusPay/createOrderSanskarPayment"
    let Kdeleteaccountapi        = "user/user_meta/deleteUser"
}

//http://app.sanskargroup.in/sanskar/index.php/data_model/videos/Video_control/get_video_meta_data
//params:-
//user_id,video_id

//http://app.sanskargroup.in/sanskar/index.php/data_model/bhajan/Bhajan/get_bhajan_meta_data
// params:-
//user_id,bhajan_id


//http://192.168.0.165/sanskar/index.php/data_model/videos/Video_control/get_related_bhajan


//http://182.76.107.25/totalbhakti/
//http://182.76.107.25/sanskar/


//http://164.52.192.251/sanskar/index.php/data_model/videos


//http://164.52.192.251/sanskar/index.php/data_model/videos/Video_control/home_page_videos

//Login_record/device_logout
