//
//  FirstViewController.h
//  Ios Storage
//
//  Created by Surbhi on 5/3/14.
//  Copyright (c) 2014 ___SurbhiSinghal___. All rights reserved.


//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface FirstViewController : UIViewController{
    sqlite3  *my_dbname;
}
- (IBAction)save:(id)sender;

@property (retain,nonatomic) NSString *databaseName, *tableName;
@property (readwrite,nonatomic) int numberOfRows;
@property (readwrite,nonatomic) NSMutableArray *dataList;
@property (readwrite,nonatomic) BOOL table_ok,db_open_status;
@property (retain,nonatomic) NSArray *my_columns_names;
-(IBAction)textFieldReturn:(id)sender;




-(BOOL)openDBWithSQLName:(NSString*)sqlname;
-(BOOL)createTable:(NSString*)tablename WithColumns:(NSArray*)columnNames;
-(BOOL)addItemstoTable:(NSString*)usetable WithColumnValues:(NSDictionary*)valueObject;
-(void)closeDB;
@end
