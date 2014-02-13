//
//  VideoTableViewController.m
//  video
//
//  Created by 駿逸 陳 on 2014/2/13.
//  Copyright (c) 2014年 駿逸 陳. All rights reserved.
//

#import "VideoTableViewController.h"
#import "JSONKit.h"
#import "VideoCell.h"
#import "ShowMoviesViewController.h"

@interface VideoTableViewController ()

@end

@implementation VideoTableViewController
@synthesize resultDict;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*
     * 分析 movie
     */
    NSString *searchWords = @"hobbit";
    NSString *urlStr = [NSString stringWithFormat:@"http://api.movies.io/movies/search?q=%@",searchWords];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *jsonStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    self.resultDict = [jsonStr objectFromJSONString];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.resultDict objectForKey:@"movies"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"videoCell";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    cell.Title.text = [NSString stringWithFormat:@"%@", [[[self.resultDict objectForKey:@"movies"] objectAtIndex:indexPath.row] objectForKey:@"title"]];
    cell.SubTitle.text = [NSString stringWithFormat:@"%@", [[[self.resultDict objectForKey:@"movies"] objectAtIndex:indexPath.row] objectForKey:@"plot"]];
    /* image */
    NSString *ImageURL = [NSString stringWithFormat:@"%@", [[[[[self.resultDict objectForKey:@"movies"] objectAtIndex:indexPath.row] objectForKey:@"poster"] objectForKey:@"urls"] objectForKey:@"w154"]];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    cell.Image.image = [UIImage imageWithData:imageData];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *videoURL = [NSString stringWithFormat:@"%@", [[[[self.resultDict objectForKey:@"movies"] objectAtIndex:indexPath.row] objectForKey:@"trailer"] objectForKey:@"url"]];
    [self performSegueWithIdentifier:@"showVideo" sender:videoURL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"sender = %@", sender);
    // ensure this is the Seque which is leading to the detail view
    if ([[segue identifier] isEqualToString:@"showVideo"])
    {
        ShowMoviesViewController *detail = [segue destinationViewController];
        [detail setDetailItem:sender];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
