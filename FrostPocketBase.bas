B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13
@EndOfDesignText@
#Event: OnCommand(command as String, data as String)

Sub Class_Globals
	Private mEventName As String
	Private mCallBack As Object
	
	Private CurrentInstance As JavaObject
	Private pocketbaseInstance As JavaObject
End Sub

'Initializes the object.
	Public Sub Initialize(Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	CurrentInstance = Me
	
	pocketbaseInstance.InitializeStatic("pocketbaseMobile.PocketbaseMobile")
	CurrentInstance.RunMethod("setEventCallback", Array(Me))
	CurrentInstance.RunMethod("setPocketbaseCallbackListener", Null)
End Sub

Public Sub Start(DataPath As String, HostName As String, Port As String, EnableApiLogs As Boolean)
	pocketbaseInstance.RunMethod("startPocketbase", Array As Object(DataPath, HostName, Port, EnableApiLogs))
End Sub

Public Sub Stop
	 pocketbaseInstance.RunMethod("stopPocketbase", Null)
End Sub

Public Sub Version As String
	Return pocketbaseInstance.RunMethod("getVersion", Null)
End Sub

'Sub to receive java events of Pocketbase commands
Private Sub On_Pocketbase_Command(command As String, data As String)
	CallSubDelayed3(mCallBack,  mEventName & "_" & "OnCommand", command, data)
End Sub

#If Java
import anywheresoftware.b4a.B4AClass;
import pocketbaseMobile.PocketbaseMobile;
import pocketbaseMobile.*;


static B4AClass target;

public void setEventCallback(B4AClass target) {
  this.target = target;
}

public void setPocketbaseCallbackListener() {

    PocketbaseMobile.registerNativeBridgeCallback(new NativeBridge() {
        @Override
		    public String handleCallback(String command, String data) {

            target.getBA().raiseEventFromDifferentThread(target, null, 0, "on_pocketbase_command", false, new Object[] {
             command,
             data
            });

            // Return response back to Pocketbase
            return "response from native";
        }
    });
}

#End If
