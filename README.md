
### 模仿QQ的录音功能

#### 注意：

1. 需要导入__Masonry__
2. 要在__真机__上才能使用录音功能
3. 要使用录音功能需要在功能的plist文件中加关键字__NSMicrophoneUsageDescription__


#### 使用：
	//导入
	#import "SRView.h"
	
	//初始化
	- (SRView *)viewSR {
    	if (!_viewSR) {
        	_viewSR = [SRView createSRView];
        	_viewSR.delegate = self;
	        _viewSR.frame = CGRectMake(0, 	CGRectGetHeight([UIScreen mainScreen].bounds)-	kSRViewHeight, CGRectGetWidth([UIScreen 	mainScreen].bounds), kSRViewHeight);
    	}
    	return _viewSR;
	}

	//对外开放的两个代理协议
	- (void)sr_viewDidCancel:(SRView *)view_SR {
    	//your code
	}

	- (void)sr_viewDidConfirm:(SRView *)view_SR recordPath:(	NSString *)path duration:(NSString *)duration {
    	//your code
	}

	//在按钮的点击方法中添加到视图上
	- (IBAction)showRecordView:(id)sender {
		//NSMicrophoneUsageDescription
	    [self.view addSubview:self.viewSR];
	}
	
	
#### 参考：

ChatKitDemo	 作者：余强（抱歉没有在github上找见）

SpectrumView 作者：黄国裕（抱歉没有在github上找见）
