/*****************************************************************************
 * open.m: MacOS X plugin for vlc
 *****************************************************************************
 * Copyright (C) 2002-2003 VideoLAN
 * $Id: open.m,v 1.29 2003/04/15 14:05:13 hartman Exp $
 *
 * Authors: Jon Lech Johansen <jon-vl@nanocrew.net> 
 *          Christophe Massiot <massiot@via.ecp.fr>
 *          Derk-Jan Hartman <thedj@users.sourceforge.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111, USA.
 *****************************************************************************/

/*****************************************************************************
 * Preamble
 *****************************************************************************/
#include <stdlib.h>                                      /* malloc(), free() */
#include <sys/param.h>                                    /* for MAXPATHLEN */
#include <string.h>

#include <paths.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/IOBSD.h>
#include <IOKit/storage/IOMedia.h>
#include <IOKit/storage/IOCDMedia.h>
#include <IOKit/storage/IODVDMedia.h>

#include "intf.h"
#include "playlist.h"
#include "open.h"

#include "netutils.h"

/*****************************************************************************
 * GetEjectableMediaOfClass 
 *****************************************************************************/
NSArray *GetEjectableMediaOfClass( const char *psz_class )
{
    io_object_t next_media;
    mach_port_t master_port;
    kern_return_t kern_result;
    NSArray *o_devices = nil;
    NSMutableArray *p_list = nil;
    io_iterator_t media_iterator;
    CFMutableDictionaryRef classes_to_match;

    kern_result = IOMasterPort( MACH_PORT_NULL, &master_port );
    if( kern_result != KERN_SUCCESS )
    {
        return( nil );
    }
    
    classes_to_match = IOServiceMatching( psz_class );
    if( classes_to_match == NULL )
    {
        return( nil );
    }
    
    CFDictionarySetValue( classes_to_match, CFSTR( kIOMediaEjectable ), 
                          kCFBooleanTrue );
    
    kern_result = IOServiceGetMatchingServices( master_port, classes_to_match, 
                                                &media_iterator );
    if( kern_result != KERN_SUCCESS )
    {
        return( nil );
    }

    p_list = [NSMutableArray arrayWithCapacity: 1];
    
    next_media = IOIteratorNext( media_iterator );
    if( next_media != NULL )
    {
        char psz_buf[0x32];
        size_t dev_path_length;
        CFTypeRef str_bsd_path;
    
        do
        {
            str_bsd_path = IORegistryEntryCreateCFProperty( next_media,
                                                            CFSTR( kIOBSDName ),
                                                            kCFAllocatorDefault,
                                                            0 );
            if( str_bsd_path == NULL )
            {
                IOObjectRelease( next_media );
                continue;
            }
            
            snprintf( psz_buf, sizeof(psz_buf), "%s%c", _PATH_DEV, 'r' );
            dev_path_length = strlen( psz_buf );
            
            if( CFStringGetCString( str_bsd_path,
                                    (char*)&psz_buf + dev_path_length,
                                    sizeof(psz_buf) - dev_path_length,
                                    kCFStringEncodingASCII ) )
            {
                [p_list addObject: [NSString stringWithCString: psz_buf]];
            }
            
            CFRelease( str_bsd_path );
            
            IOObjectRelease( next_media );
        
        } while( ( next_media = IOIteratorNext( media_iterator ) ) != NULL );
    }
    
    IOObjectRelease( media_iterator );

    o_devices = [NSArray arrayWithArray: p_list];

    return( o_devices );
}

/*****************************************************************************
 * VLCOpen implementation 
 *****************************************************************************/
@implementation VLCOpen

- (void)awakeFromNib
{
    intf_thread_t * p_intf = [NSApp getIntf];
    char * psz_sout = config_GetPsz( p_intf, "sout" );

    if ( psz_sout != NULL && *psz_sout )
    {
        [o_sout_cbox setState: YES];
    }
    else
    {
        [o_sout_cbox setState: NO];
    }
    free(psz_sout);

    [o_panel setTitle: _NS("Open Source")];
    [o_mrl_lbl setTitle: _NS("Media Resource Locator (MRL)")];
    [o_ckbox_enqueue setTitle: _NS("Only enqueue in playlist, do not play")];

    [o_btn_ok setTitle: _NS("OK")];
    [o_btn_cancel setTitle: _NS("Cancel")];

    [[o_tabview tabViewItemAtIndex: 0] setLabel: _NS("File")];
    [[o_tabview tabViewItemAtIndex: 1] setLabel: _NS("Disc")];
    [[o_tabview tabViewItemAtIndex: 2] setLabel: _NS("Network")];

    [o_file_btn_browse setTitle: _NS("Browse...")];
    [o_file_stream setTitle: _NS("Treat as a pipe rather than as a file")];

    [o_disc_device_lbl setStringValue: _NS("Device name")];
    [o_disc_title_lbl setStringValue: _NS("Title")];
    [o_disc_chapter_lbl setStringValue: _NS("Chapter")];
    [o_disc_videots_btn_browse setTitle: _NS("Browse...")];
    [o_disc_dvd_menus setTitle: _NS("Use DVD menus (EXPERIMENTAL)")];

    [[o_disc_type cellAtRow:0 column:0] setTitle: _NS("VIDEO_TS folder")];
    [[o_disc_type cellAtRow:1 column:0] setTitle: _NS("DVD")];
    [[o_disc_type cellAtRow:2 column:0] setTitle: _NS("VCD")];

    [o_net_udp_port_lbl setStringValue: _NS("Port")];
    [o_net_udpm_addr_lbl setStringValue: _NS("Address")];
    [o_net_udpm_port_lbl setStringValue: _NS("Port")];
    [o_net_http_url_lbl setStringValue: _NS("URL")];

    [[o_net_mode cellAtRow:0 column:0] setTitle: _NS("UDP/RTP")];
    [[o_net_mode cellAtRow:1 column:0] setTitle: _NS("UDP/RTP Multicast")];
    [[o_net_mode cellAtRow:2 column:0] setTitle: _NS("HTTP/FTP/MMS")];

    [o_net_udp_port setIntValue: config_GetInt( p_intf, "server-port" )];
    [o_net_udp_port_stp setIntValue: config_GetInt( p_intf, "server-port" )];

    [o_sout_cbox setTitle: _NS("Stream output:")];
    [o_sout_btn_ok setTitle: _NS("OK")];
    [o_sout_settings setTitle: _NS("Settings...")];
    [o_sout_mrl_lbl setTitle: _NS("Stream output MRL")];
    
    [o_sout_access_lbl setTitle: _NS("Output Method")];
    [[o_sout_access cellAtRow:0 column:0] setTitle: _NS("File")];
    [[o_sout_access cellAtRow:1 column:0] setTitle: _NS("HTTP")];
    [[o_sout_access cellAtRow:2 column:0] setTitle: _NS("UDP")];
    [[o_sout_access cellAtRow:3 column:0] setTitle: _NS("RTP")];

    [o_sout_file_btn_browse setTitle: _NS("Browse...")];
    [o_sout_udp_addr_lbl setStringValue: _NS("Address")];
    [o_sout_udp_port_lbl setStringValue: _NS("Port")];

    [o_sout_mux_lbl setTitle: _NS("Encapsulation Method")];
    [[o_sout_mux cellAtRow:0 column:0] setTitle: _NS("MPEG TS")];
    [[o_sout_mux cellAtRow:0 column:1] setTitle: _NS("MPEG PS")];
    [[o_sout_mux cellAtRow:0 column:2] setTitle: _NS("AVI")];
    [[o_sout_mux cellAtRow:0 column:3] setTitle: _NS("Ogg")];
    
    [o_file_sub_ckbox setTitle: _NS("Load subtitles file:")];
    [o_file_sub_btn_settings setTitle: _NS("Settings...")];
    [o_file_sub_btn_browse setTitle: _NS("Browse...")];
    [o_file_sub_override setTitle: _NS("Override")];
    [o_file_sub_delay_lbl setStringValue: _NS("delay")];
    [o_file_sub_delay_stp setEnabled: NO];
    [o_file_sub_fps_lbl setStringValue: _NS("fps")];
    [o_file_sub_fps_stp setEnabled: NO];
    [o_file_sub_ok_btn setStringValue: _NS("OK")];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(openFilePathChanged:)
        name: NSControlTextDidChangeNotification
        object: o_file_path];

    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(openDiscInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: o_disc_device];
    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(openDiscInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: o_disc_title];
    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(openDiscInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: o_disc_chapter];
    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(openDiscInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: o_disc_videots_folder];

    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(openNetInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: o_net_udp_port];
    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(openNetInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: o_net_udpm_addr];
    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(openNetInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: o_net_udpm_port];
    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(openNetInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: o_net_http_url];

    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(soutInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: o_sout_file_path];
    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(soutInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: o_sout_udp_addr];
    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(soutInfoChanged:)
        name: NSControlTextDidChangeNotification
        object: o_sout_udp_port];
}

- (void)openTarget:(int)i_type
{
    int i_result;

    [o_tabview selectTabViewItemAtIndex: i_type];
    [o_file_sub_ckbox setState: NSOffState];
    
    i_result = [NSApp runModalForWindow: o_panel];
    [o_panel close];

    if( i_result )
    {
        NSString *o_sout = [o_sout_mrl stringValue];
        intf_thread_t * p_intf = [NSApp getIntf];
        
        if ( [o_sout_cbox state] )
        {
            config_PutPsz( p_intf, "sout", [o_sout lossyCString] );
        }
        else
        {
            config_PutPsz( p_intf, "sout", "" );
        }

        NSString *o_source = [o_mrl stringValue];
        BOOL b_enq = [o_ckbox_enqueue state] == NSOnState ? YES : NO;
        NSString *subPath = [o_file_sub_path stringValue];
        
        [o_playlist appendArray: 
            [NSArray arrayWithObject: o_source] atPos: -1 enqueue:b_enq];
        
        if (([o_file_sub_ckbox state] == NSOnState) && !([subPath isEqualTo: @""]))
        {
            config_PutPsz( p_intf, "sub-file", strdup( [subPath cString] ) );
            if ( [o_file_sub_override state] )
            {
                config_PutInt( p_intf, "sub-delay", (int)( [o_file_sub_delay intValue] * 10 ) );
                config_PutFloat( p_intf, "sub-fps", [o_file_sub_fps floatValue] );
            }
        }
        else
        {
            config_PutPsz( p_intf, "sub-file", "" );
            config_PutInt( p_intf, "sub-delay", 0 );
            config_PutFloat( p_intf, "sub-fps", 0.0 );
        }
    }
    [self soutModeChanged: nil];
}

- (void)tabView:(NSTabView *)o_tv didSelectTabViewItem:(NSTabViewItem *)o_tvi
{
    NSString *o_label = [o_tvi label];

    if( [o_label isEqualToString: _NS("File")] )
    {
        [self openFilePathChanged: nil];
    }
    else if( [o_label isEqualToString: _NS("Disc")] )
    {
        [self openDiscTypeChanged: nil];
    }
    else if( [o_label isEqualToString: _NS("Network")] )
    {
        [self openNetModeChanged: nil];
    }  
}

- (IBAction)openFileGeneric:(id)sender
{
    [self openFilePathChanged: nil];
    [self openTarget: 0];
}

- (IBAction)openDisc:(id)sender
{
    [self openDiscTypeChanged: nil];
    [self openTarget: 1];
}

- (IBAction)openNet:(id)sender
{
    [self openNetModeChanged: nil];
    [self openTarget: 2];
}

- (void)openFilePathChanged:(NSNotification *)o_notification
{
    NSString *o_mrl_string;
    NSString *o_filename = [o_file_path stringValue];
    NSString *o_ext = [o_filename pathExtension];
    vlc_bool_t b_stream = [o_file_stream state];
    BOOL b_dir = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:o_filename isDirectory:&b_dir];

    if( b_dir )
    {
        o_mrl_string = [NSString stringWithFormat: @"dir:%@", o_filename];
    }
    else if( [o_ext isEqualToString: @"bin"] ||
        [o_ext isEqualToString: @"cue"] ||
        [o_ext isEqualToString: @"vob"] ||
        [o_ext isEqualToString: @"iso"] )
    {
        o_mrl_string = o_filename;
    }
    else
    {
        o_mrl_string = [NSString stringWithFormat: @"%s://%@",
                        b_stream ? "stream" : "file",
                        o_filename];
    }
    [o_mrl setStringValue: o_mrl_string]; 
}

- (IBAction)openFileBrowse:(id)sender
{
    NSOpenPanel *o_open_panel = [NSOpenPanel openPanel];
    
    [o_open_panel setAllowsMultipleSelection: NO];
    [o_open_panel setCanChooseDirectories: YES];
    [o_open_panel setTitle: _NS("Open File")];
    [o_open_panel setPrompt: _NS("Open")];

    [o_open_panel beginSheetForDirectory:nil
        file:nil
        types:nil
        modalForWindow:[sender window]
        modalDelegate: self
        didEndSelector: @selector(pathChosenInPanel: 
                        withReturn:
                        contextInfo:)
        contextInfo: nil];
}

- (void)pathChosenInPanel: (NSOpenPanel *) sheet withReturn:(int)returnCode contextInfo:(void  *)contextInfo
{
    if (returnCode == NSFileHandlingPanelOKButton)
    {
        NSString *o_filename = [[sheet filenames] objectAtIndex: 0];
        [o_file_path setStringValue: o_filename];
        [self openFilePathChanged: nil];
    }
}

- (IBAction)openFileStreamChanged:(id)sender
{
    [self openFilePathChanged: nil];
}

- (IBAction)openDiscTypeChanged:(id)sender
{
    NSString *o_type;
    vlc_bool_t b_device, b_menus, b_title_chapter;
    
    [o_disc_device removeAllItems];
    b_title_chapter = ![o_disc_dvd_menus state];
    
    o_type = [[o_disc_type selectedCell] title];

    if ( [o_type isEqualToString: _NS("VIDEO_TS folder")] )
    {
        b_device = 0; b_menus = 1;
    }
    else
    {
        NSArray *o_devices;
        NSString *o_disc;
        const char *psz_class = NULL;
        b_device = 1;

        if ( [o_type isEqualToString: _NS("VCD")] )
        {
            psz_class = kIOCDMediaClass;
            o_disc = o_type;
            b_menus = 0; b_title_chapter = 1;
            [o_disc_dvd_menus setState: FALSE];
        }
        else
        {
            psz_class = kIODVDMediaClass;
            o_disc = o_type;
            b_menus = 1;
        }
    
        o_devices = GetEjectableMediaOfClass( psz_class );
        if ( o_devices != nil )
        {
            int i_devices = [o_devices count];
        
            if ( i_devices )
            {
                int i;
        
                for( i = 0; i < i_devices; i++ )
                {
                    [o_disc_device 
                        addItemWithObjectValue: [o_devices objectAtIndex: i]];
                }

                [o_disc_device selectItemAtIndex: 0];
            }
            else
            {
                [o_disc_device setStringValue: 
                    [NSString stringWithFormat: _NS("No %@s found"), o_disc]];
            }
        }
    }

    [o_disc_device setEnabled: b_device];
    [o_disc_title setEnabled: b_title_chapter];
    [o_disc_title_stp setEnabled: b_title_chapter];
    [o_disc_chapter setEnabled: b_title_chapter];
    [o_disc_chapter_stp setEnabled: b_title_chapter];
    [o_disc_videots_folder setEnabled: !b_device];
    [o_disc_videots_btn_browse setEnabled: !b_device];
    [o_disc_dvd_menus setEnabled: b_menus];

    [self openDiscInfoChanged: nil];
}

- (IBAction)openDiscStepperChanged:(id)sender
{
    int i_tag = [sender tag];

    if( i_tag == 0 )
    {
        [o_disc_title setIntValue: [o_disc_title_stp intValue]];
    }
    else if( i_tag == 1 )
    {
        [o_disc_chapter setIntValue: [o_disc_chapter_stp intValue]];
    }

    [self openDiscInfoChanged: nil];
}

- (void)openDiscInfoChanged:(NSNotification *)o_notification
{
    NSString *o_type;
    NSString *o_device;
    NSString *o_videots;
    NSString *o_mrl_string;
    int i_title, i_chapter;
    vlc_bool_t b_menus;

    o_type = [[o_disc_type selectedCell] title];
    o_device = [o_disc_device stringValue];
    i_title = [o_disc_title intValue];
    i_chapter = [o_disc_chapter intValue];
    o_videots = [o_disc_videots_folder stringValue];
    b_menus = [o_disc_dvd_menus state];

    if ( [o_type isEqualToString: _NS("VCD")] )
    {
        if ( [o_device isEqualToString:
                [NSString stringWithFormat: _NS("No %@s found"), o_type]] )
            o_device = @"";
        o_mrl_string = [NSString stringWithFormat: @"vcd://%@@%i,%i",
                        o_device, i_title, i_chapter]; 
    }
    else if ( [o_type isEqualToString: _NS("DVD")] )
    {
        if ( [o_device isEqualToString:
                [NSString stringWithFormat: _NS("No %@s found"), o_type]] )
            o_device = @"";
        if ( b_menus )
            o_mrl_string = [NSString stringWithFormat: @"dvdplay://%@",
                            o_device]; 
        else
            o_mrl_string = [NSString stringWithFormat: @"dvdold://%@@%i,%i",
                            o_device, i_title, i_chapter]; 
    }
    else /* VIDEO_TS folder */
    {
        if ( b_menus )
            o_mrl_string = [NSString stringWithFormat: @"dvdplay://%@",
                            o_videots]; 
        else
            o_mrl_string = [NSString stringWithFormat: @"dvdread://%@@%i,%i",
                            o_videots, i_title, i_chapter]; 
    }

    [o_mrl setStringValue: o_mrl_string]; 
}

- (IBAction)openDiscMenusChanged:(id)sender
{
    [self openDiscInfoChanged: nil];
    [self openDiscTypeChanged: nil];
}

- (IBAction)openVTSBrowse:(id)sender
{
    NSOpenPanel *o_open_panel = [NSOpenPanel openPanel];

    [o_open_panel setAllowsMultipleSelection: NO];
    [o_open_panel setCanChooseFiles: NO];
    [o_open_panel setCanChooseDirectories: YES];
    [o_open_panel setTitle: _NS("Open VIDEO_TS Directory")];
    [o_open_panel setPrompt: _NS("Open")];

    if( [o_open_panel runModalForDirectory: nil
            file: nil types: nil] == NSOKButton )
    {
        NSString *o_dirname = [[o_open_panel filenames] objectAtIndex: 0];
        [o_disc_videots_folder setStringValue: o_dirname];
        [self openDiscInfoChanged: nil];
    }
}

- (IBAction)openNetModeChanged:(id)sender
{
    NSString *o_mode;
    BOOL b_udp = FALSE;
    BOOL b_udpm = FALSE;
    BOOL b_http = FALSE;

    o_mode = [[o_net_mode selectedCell] title];

    if( [o_mode isEqualToString: _NS("UDP/RTP")] ) b_udp = TRUE;   
    else if( [o_mode isEqualToString: _NS("UDP/RTP Multicast")] ) b_udpm = TRUE;
    else if( [o_mode isEqualToString: _NS("HTTP/FTP/MMS")] ) b_http = TRUE;

    [o_net_udp_port setEnabled: b_udp];
    [o_net_udp_port_stp setEnabled: b_udp];
    [o_net_udpm_addr setEnabled: b_udpm];
    [o_net_udpm_port setEnabled: b_udpm];
    [o_net_udpm_port_stp setEnabled: b_udpm];
    [o_net_http_url setEnabled: b_http];

    [self openNetInfoChanged: nil];
}

- (IBAction)openNetStepperChanged:(id)sender
{
    int i_tag = [sender tag];

    if( i_tag == 0 )
    {
        [o_net_udp_port setIntValue: [o_net_udp_port_stp intValue]];
    }
    else if( i_tag == 1 )
    {
        [o_net_udpm_port setIntValue: [o_net_udpm_port_stp intValue]];
    }

    [self openNetInfoChanged: nil];
}

- (void)openNetInfoChanged:(NSNotification *)o_notification
{
    NSString *o_mode;
    NSString *o_mrl_string = [NSString string];
    intf_thread_t * p_intf = [NSApp getIntf];

    o_mode = [[o_net_mode selectedCell] title];

    if( [o_mode isEqualToString: _NS("UDP/RTP")] )
    {
        int i_port = [o_net_udp_port intValue];

        o_mrl_string = [NSString stringWithString: @"udp://"]; 

        if( i_port != config_GetInt( p_intf, "server-port" ) )
        {
            o_mrl_string = 
                [o_mrl_string stringByAppendingFormat: @"@:%i", i_port]; 
        } 
    }
    else if( [o_mode isEqualToString: _NS("UDP/RTP Multicast")] ) 
    {
        NSString *o_addr = [o_net_udpm_addr stringValue];
        int i_port = [o_net_udpm_port intValue];

        o_mrl_string = [NSString stringWithFormat: @"udp://@%@", o_addr]; 

        if( i_port != config_GetInt( p_intf, "server-port" ) )
        {
            o_mrl_string = 
                [o_mrl_string stringByAppendingFormat: @":%i", i_port]; 
        } 
    }
    else if( [o_mode isEqualToString: _NS("HTTP/FTP/MMS")] )
    {
        NSString *o_url = [o_net_http_url stringValue];

        if ( ![o_url hasPrefix:@"http:"] && ![o_url hasPrefix:@"ftp:"]
              && ![o_url hasPrefix:@"mms"] )
            o_mrl_string = [NSString stringWithFormat: @"http://%@", o_url];
        else
            o_mrl_string = o_url;
    }

    [o_mrl setStringValue: o_mrl_string];
}

- (IBAction)soutChanged:(id)sender;
{
    if ([o_sout_cbox state] == NSOnState)
    {
        [o_sout_settings setEnabled:YES];
    }
    else
    {
        [o_sout_settings setEnabled:NO];
    }
}

- (IBAction)soutSettings:(id)sender
{
    [self soutModeChanged: nil];
    [NSApp beginSheet: o_sout_sheet
        modalForWindow: [sender window]
        modalDelegate: self
        didEndSelector: NULL
        contextInfo: nil];
}

- (IBAction)soutFileBrowse:(id)sender
{
    NSSavePanel *o_save_panel = [NSSavePanel savePanel];
    NSString *o_mux_string;
    if ( [[[o_sout_mux selectedCell] title] isEqualToString: _NS("MPEG PS")] )
        o_mux_string = @"vob";
    else if ( [[[o_sout_mux selectedCell] title] isEqualToString: _NS("AVI")] )
        o_mux_string = @"avi";
    else if ( [[[o_sout_mux selectedCell] title] isEqualToString: _NS("Ogg")] )
        o_mux_string = @"ogm";
    else
        o_mux_string = @"ts";

    NSString * o_name = [NSString stringWithFormat: @"vlc-output.%@",
                         o_mux_string];

    [o_save_panel setTitle: _NS("Save File")];
    [o_save_panel setPrompt: _NS("Save")];

    if( [o_save_panel runModalForDirectory: nil
            file: o_name] == NSOKButton )
    {
        NSString *o_filename = [o_save_panel filename];
        [o_sout_file_path setStringValue: o_filename];
        [self soutInfoChanged: nil];
    }
}

- (void)soutModeChanged:(NSNotification *)o_notification
{
    NSString *o_mode;
    BOOL b_file = FALSE;
    BOOL b_net = FALSE;

    o_mode = [[o_sout_access selectedCell] title];

    if( [o_mode isEqualToString: _NS("File")] ) b_file = TRUE;   
    else if( [o_mode isEqualToString: _NS("UDP")] ) b_net = TRUE;
    else if( [o_mode isEqualToString: _NS("RTP")] ) b_net = TRUE;

    [o_sout_file_path setEnabled: b_file];
    [o_sout_file_btn_browse setEnabled: b_file];
    [o_sout_udp_addr setEnabled: !b_file];
    [o_sout_udp_port setEnabled: !b_file];
    [o_sout_udp_port_stp setEnabled: !b_file ];
    
    [[o_sout_mux cellAtRow:0 column: 1] setEnabled: !b_net];
    [[o_sout_mux cellAtRow:0 column: 2] setEnabled: !b_net];
    [[o_sout_mux cellAtRow:0 column: 3] setEnabled: !b_net];
    if ( b_net )
    {
        [o_sout_mux selectCellAtRow:0 column: 0];
    }

    [self soutInfoChanged: nil];
}

- (void)soutInfoChanged:(NSNotification *)o_notification
{
    NSString *o_mode;
    NSString *o_mux;
    NSString *o_mrl_string;
    NSString *o_mux_string;

    o_mode = [[o_sout_access selectedCell] title];
    o_mux = [[o_sout_mux selectedCell] title];

    if ( [o_mux isEqualToString: _NS("AVI")] ) o_mux_string = @"avi";
    else if ( [o_mux isEqualToString: _NS("Ogg")] ) o_mux_string = @"ogg";
    else if ( [o_mux isEqualToString: _NS("MPEG PS")] ) o_mux_string = @"ps";
    else o_mux_string = @"ts";

    if ( [o_mode isEqualToString: _NS("File")] )
    {
        o_mrl_string = [NSString stringWithFormat: @"file/%@://%@",
                        o_mux_string, [o_sout_file_path stringValue]];
    }
    else if ( [o_mode isEqualToString: _NS("HTTP")] )
    {
        o_mrl_string = [NSString stringWithFormat: @"http/%@://%@:%i",
                        o_mux_string, [o_sout_udp_addr stringValue],
                        [o_sout_udp_port intValue]];
    }
    else if ( [o_mode isEqualToString: _NS("UDP")] )
    {
        o_mrl_string = [NSString stringWithFormat: @"udp/%@://%@:%i",
                        o_mux_string, [o_sout_udp_addr stringValue],
                        [o_sout_udp_port intValue]];
    }
    else
    {
        o_mrl_string = [NSString stringWithFormat: @"rtp/%@://%@:%i",
                        o_mux_string, [o_sout_udp_addr stringValue],
                        [o_sout_udp_port intValue]];
    }


    [o_sout_mrl setStringValue: o_mrl_string];
}

- (IBAction)soutStepperChanged:(id)sender
{
    [o_sout_udp_port setIntValue: [o_sout_udp_port_stp intValue]];
    [self soutInfoChanged: nil];
}

- (IBAction)soutCloseSheet:(id)sender
{
    [o_sout_sheet orderOut:sender];
    [NSApp endSheet: o_sout_sheet];
}

- (IBAction)openFile:(id)sender
{
    NSOpenPanel *o_open_panel = [NSOpenPanel openPanel];
    
    [o_open_panel setAllowsMultipleSelection: YES];
    [o_open_panel setCanChooseDirectories: YES];
    [o_open_panel setTitle: _NS("Open File")];
    [o_open_panel setPrompt: _NS("Open")];
    
    if( [o_open_panel runModalForDirectory: nil
            file: nil types: nil] == NSOKButton )
    {
        intf_thread_t * p_intf = [NSApp getIntf];
        config_PutPsz( p_intf, "sout", NULL );
        
        NSArray *o_values = [[o_open_panel filenames]
                sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        [o_playlist appendArray: o_values atPos: -1 enqueue:NO];
        config_PutPsz( p_intf, "sub-file", "" );
        config_PutInt( p_intf, "sub-delay", 0 );
        config_PutFloat( p_intf, "sub-fps", 0.0 );
        config_PutPsz( p_intf, "sout", "" );
    }
}

- (IBAction)subsChanged:(id)sender
{
    if ([o_file_sub_ckbox state] == NSOnState)
    {
        [o_file_sub_btn_settings setEnabled:YES];
    }
    else
    {
        [o_file_sub_btn_settings setEnabled:NO];
    }
}

- (IBAction)subSettings:(id)sender
{
    [NSApp beginSheet: o_file_sub_sheet
        modalForWindow: [sender window]
        modalDelegate: self
        didEndSelector: NULL
        contextInfo: nil];
}

- (IBAction)subFileBrowse:(id)sender
{
    NSOpenPanel *o_open_panel = [NSOpenPanel openPanel];
    
    [o_open_panel setAllowsMultipleSelection: NO];
    [o_open_panel setTitle: _NS("Open File")];
    [o_open_panel setPrompt: _NS("Open")];

    if( [o_open_panel runModalForDirectory: nil 
            file: nil types: nil] == NSOKButton )
    {
        NSString *o_filename = [[o_open_panel filenames] objectAtIndex: 0];
        [o_file_sub_path setStringValue: o_filename];
    }
}

- (IBAction)subOverride:(id)sender
{
    BOOL b_state = [o_file_sub_override state];
    [o_file_sub_delay setEnabled: b_state];
    [o_file_sub_delay_stp setEnabled: b_state];
    [o_file_sub_fps setEnabled: b_state];
    [o_file_sub_fps_stp setEnabled: b_state];
}

- (IBAction)subDelayStepperChanged:(id)sender
{
    [o_file_sub_delay setIntValue: [o_file_sub_delay_stp intValue]];
}

- (IBAction)subFpsStepperChanged:(id)sender;
{
    [o_file_sub_fps setFloatValue: [o_file_sub_fps_stp floatValue]];
}

- (IBAction)subCloseSheet:(id)sender
{
    [o_file_sub_sheet orderOut:sender];
    [NSApp endSheet: o_file_sub_sheet];
}

- (IBAction)panelCancel:(id)sender
{
    [NSApp stopModalWithCode: 0];
}

- (IBAction)panelOk:(id)sender
{
    if( [[o_mrl stringValue] length] )
    {
        [NSApp stopModalWithCode: 1];
    }
    else
    {
        NSBeep();
    }
}

@end
