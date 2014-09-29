//
//  FirstViewController.m
//  Ios Storage
//
//  Created by Surbhi on 5/3/14.
//  Copyright (c) 2014 ___SurbhiSinghal___. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize table_ok,databaseName,dataList,my_columns_names,numberOfRows,tableName,db_open_status;

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataList=[ [NSMutableArray alloc]init];
    numberOfRows=0;
    databaseName=@"booksDatabase.sql";
    tableName=@"books";
    db_open_status=NO;
    my_columns_names=[[NSArray alloc]initWithObjects:@"bookName",@"authorName",@"description",@"publisherName",@"isbn",nil];
    if([self openDBWithSQLName:databaseName]){
        NSLog(@"database opened");

        db_open_status=YES;
        if(![self createTable:tableName WithColumns:my_columns_names]){
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"The table has not been created" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }else{
            table_ok=YES;
        }
    }else{
        NSLog(@"database not opened----");

    }
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma sqlite methods
-(BOOL)openDBWithSQLName:(NSString *)sqlname{
    BOOL is_Opened=NO;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *my_sqlfile=[[paths objectAtIndex:0]stringByAppendingPathComponent:sqlname];
    NSLog(@"value of my_sqlfile=%@",my_sqlfile);
    
    
    if(sqlite3_open([my_sqlfile UTF8String], &my_dbname)==SQLITE_OK){
        is_Opened=YES;
         NSLog(@"database opened");
        
    }else{
        NSLog(@"database not opened");

    }
    return is_Opened;
    
}

-(BOOL)createTable:(NSString *)tablename WithColumns:(NSArray *)columnNames{
    BOOL has_beencreated=NO;
    NSString *fieldSet=@"";
    char *err;
    for(int a=0;a<[columnNames count];a++){
        NSString *columnSet=[NSString stringWithFormat:@"'%@' TEXT",[columnNames objectAtIndex:a]];
        fieldSet=[fieldSet stringByAppendingString:columnSet];
        if(a<([columnNames count]-1)){
            fieldSet=[fieldSet stringByAppendingString:@", "];
        }
        
    }
    NSString *sql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@);",tableName,fieldSet];
    NSLog(@"create table command=%@",sql);

    if(sqlite3_exec(my_dbname,[sql UTF8String],NULL,NULL,&err)!=SQLITE_OK){
        sqlite3_close(my_dbname);
    }else{
        has_beencreated=YES;
    }
    return has_beencreated;
}

-(BOOL)addItemstoTable:(NSString *)usetable WithColumnValues:(NSDictionary *)valueObject{
    BOOL has_beenadded=NO;
    NSString *mycolumns=@"";
    NSString *myvalues=@"";
    for(int r=0;r<[[valueObject allKeys]count];r++){
        NSString *this_keyname=[[valueObject allKeys]objectAtIndex:r];
        mycolumns=[mycolumns stringByAppendingString:this_keyname];
        NSString *thisval=[NSString stringWithFormat:@"'%@'",[valueObject objectForKey:this_keyname]];
        myvalues=[myvalues stringByAppendingString:thisval];
        if(r<(([[valueObject allKeys]count])-1)){
            mycolumns=[mycolumns stringByAppendingString:@","];
            myvalues=[myvalues stringByAppendingString:@","];

            
        }
     }
    NSString *myinsert=[NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",usetable,mycolumns,myvalues];
    char *err;
    if(sqlite3_exec(my_dbname, [myinsert UTF8String], NULL,NULL, &err)!=SQLITE_OK){
        sqlite3_close(my_dbname);
    }else{
        has_beenadded=YES;
    }
    
    return has_beenadded;
}

-(void)closeDB{
    sqlite3_close(my_dbname);
    db_open_status=NO;
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}


- (IBAction)save:(id)sender {
    NSLog(@"save clicked");

    if(table_ok){
        if(!db_open_status){
            [self openDBWithSQLName:databaseName];
            
        }
        NSMutableDictionary *objectColsVals=[[NSMutableDictionary alloc]init];
        for(id aSubView in [self.view subviews]){
            if([aSubView isKindOfClass:[UITextField class]]){
                if ([(UITextField *)aSubView isFirstResponder]) {
                    [(UITextField *)aSubView resignFirstResponder];
                }
                int this_tag=((UITextField *)aSubView).tag;
                NSString *this_textValue=[(UITextField*)aSubView text];
                [objectColsVals setValue:this_textValue forKey:[my_columns_names objectAtIndex:this_tag]];
                ((UITextField *)aSubView).text=@"";
                
            }
        }
        if ([[objectColsVals allKeys]count]>0) {
            if([self addItemstoTable:tableName WithColumnValues:objectColsVals]){
                [self closeDB];
                NSLog(@"item added");

            }
        }
    }
}
@end
