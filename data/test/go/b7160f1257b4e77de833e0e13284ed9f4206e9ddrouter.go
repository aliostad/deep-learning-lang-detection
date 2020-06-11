// @APIVersion 1.0.0
// @Title beego Test API
// @Description beego has a very cool tools to autogenerate documents for your API
// @Contact astaxie@gmail.com
// @TermsOfServiceUrl http://beego.me/
// @License Apache 2.0
// @LicenseUrl http://www.apache.org/licenses/LICENSE-2.0.html
package routers

import (
	"github.com/ws6/sagecore/controllers"

	"github.com/astaxie/beego"
)

func init() {
	ns := beego.NewNamespace("/v1",

		beego.NSNamespace("/amms_equipment",
			beego.NSInclude(
				&controllers.AmmsEquipmentController{},
			),
		),

		beego.NSNamespace("/amms_history",
			beego.NSInclude(
				&controllers.AmmsHistoryController{},
			),
		),

		beego.NSNamespace("/analysis",
			beego.NSInclude(
				&controllers.AnalysisController{},
			),
		),

		beego.NSNamespace("/analysis_lane_index",
			beego.NSInclude(
				&controllers.AnalysisLaneIndexController{},
			),
		),

		beego.NSNamespace("/analysis_log",
			beego.NSInclude(
				&controllers.AnalysisLogController{},
			),
		),

		beego.NSNamespace("/analysis_qc",
			beego.NSInclude(
				&controllers.AnalysisQcController{},
			),
		),

		beego.NSNamespace("/analysis_qc_config",
			beego.NSInclude(
				&controllers.AnalysisQcConfigController{},
			),
		),

		beego.NSNamespace("/analysis_run",
			beego.NSInclude(
				&controllers.AnalysisRunController{},
			),
		),

		beego.NSNamespace("/analysis_run_metrics",
			beego.NSInclude(
				&controllers.AnalysisRunMetricsController{},
			),
		),

		beego.NSNamespace("/analysis_sample_layout",
			beego.NSInclude(
				&controllers.AnalysisSampleLayoutController{},
			),
		),

		beego.NSNamespace("/apex_flowcell_qcs",
			beego.NSInclude(
				&controllers.ApexFlowcellQcsController{},
			),
		),

		beego.NSNamespace("/back_slave",
			beego.NSInclude(
				&controllers.BackSlaveController{},
			),
		),

		beego.NSNamespace("/balancer",
			beego.NSInclude(
				&controllers.BalancerController{},
			),
		),

		beego.NSNamespace("/change_log",
			beego.NSInclude(
				&controllers.ChangeLogController{},
			),
		),

		beego.NSNamespace("/chemfies",
			beego.NSInclude(
				&controllers.ChemfiesController{},
			),
		),

		beego.NSNamespace("/comments",
			beego.NSInclude(
				&controllers.CommentsController{},
			),
		),

		beego.NSNamespace("/comments_table",
			beego.NSInclude(
				&controllers.CommentsTableController{},
			),
		),

		beego.NSNamespace("/dif",
			beego.NSInclude(
				&controllers.DifController{},
			),
		),

		beego.NSNamespace("/dif_failure",
			beego.NSInclude(
				&controllers.DifFailureController{},
			),
		),

		beego.NSNamespace("/dif_lane",
			beego.NSInclude(
				&controllers.DifLaneController{},
			),
		),

		beego.NSNamespace("/firefly_tracker",
			beego.NSInclude(
				&controllers.FireflyTrackerController{},
			),
		),

		beego.NSNamespace("/firefly_tracker_flowcell",
			beego.NSInclude(
				&controllers.FireflyTrackerFlowcellController{},
			),
		),

		beego.NSNamespace("/flowcell",
			beego.NSInclude(
				&controllers.FlowcellController{},
			),
		),

		beego.NSNamespace("/flowcell_automation",
			beego.NSInclude(
				&controllers.FlowcellAutomationController{},
			),
		),

		beego.NSNamespace("/flowcell_ext",
			beego.NSInclude(
				&controllers.FlowcellExtController{},
			),
		),

		beego.NSNamespace("/flowcell_log",
			beego.NSInclude(
				&controllers.FlowcellLogController{},
			),
		),

		beego.NSNamespace("/flowcell_raw_info",
			beego.NSInclude(
				&controllers.FlowcellRawInfoController{},
			),
		),

		beego.NSNamespace("/flowcell_read_sav",
			beego.NSInclude(
				&controllers.FlowcellReadSavController{},
			),
		),

		beego.NSNamespace("/flowcell_reagent",
			beego.NSInclude(
				&controllers.FlowcellReagentController{},
			),
		),

		beego.NSNamespace("/flowcell_resource",
			beego.NSInclude(
				&controllers.FlowcellResourceController{},
			),
		),

		beego.NSNamespace("/flowcell_samplesheet",
			beego.NSInclude(
				&controllers.FlowcellSamplesheetController{},
			),
		),

		beego.NSNamespace("/flowcell_temperature",
			beego.NSInclude(
				&controllers.FlowcellTemperatureController{},
			),
		),

		beego.NSNamespace("/index",
			beego.NSInclude(
				&controllers.IndexController{},
			),
		),

		beego.NSNamespace("/index_group",
			beego.NSInclude(
				&controllers.IndexGroupController{},
			),
		),

		beego.NSNamespace("/index_grouping",
			beego.NSInclude(
				&controllers.IndexGroupingController{},
			),
		),

		beego.NSNamespace("/index_library",
			beego.NSInclude(
				&controllers.IndexLibraryController{},
			),
		),

		beego.NSNamespace("/instrument",
			beego.NSInclude(
				&controllers.InstrumentController{},
			),
		),

		beego.NSNamespace("/instrument_config",
			beego.NSInclude(
				&controllers.InstrumentConfigController{},
			),
		),

		beego.NSNamespace("/instrument_config_track",
			beego.NSInclude(
				&controllers.InstrumentConfigTrackController{},
			),
		),

		beego.NSNamespace("/instrument_group",
			beego.NSInclude(
				&controllers.InstrumentGroupController{},
			),
		),

		beego.NSNamespace("/instrument_maintenance",
			beego.NSInclude(
				&controllers.InstrumentMaintenanceController{},
			),
		),

		beego.NSNamespace("/instrument_scheduler",
			beego.NSInclude(
				&controllers.InstrumentSchedulerController{},
			),
		),

		beego.NSNamespace("/instrument_type",
			beego.NSInclude(
				&controllers.InstrumentTypeController{},
			),
		),

		beego.NSNamespace("/lane",
			beego.NSInclude(
				&controllers.LaneController{},
			),
		),

		beego.NSNamespace("/lane_group",
			beego.NSInclude(
				&controllers.LaneGroupController{},
			),
		),

		beego.NSNamespace("/lane_grouping",
			beego.NSInclude(
				&controllers.LaneGroupingController{},
			),
		),

		beego.NSNamespace("/lane_index",
			beego.NSInclude(
				&controllers.LaneIndexController{},
			),
		),

		beego.NSNamespace("/lane_qc",
			beego.NSInclude(
				&controllers.LaneQcController{},
			),
		),

		beego.NSNamespace("/lane_read_sav",
			beego.NSInclude(
				&controllers.LaneReadSavController{},
			),
		),

		beego.NSNamespace("/lane_report",
			beego.NSInclude(
				&controllers.LaneReportController{},
			),
		),

		beego.NSNamespace("/lane_report_combined",
			beego.NSInclude(
				&controllers.LaneReportCombinedController{},
			),
		),

		beego.NSNamespace("/lane_report_surface",
			beego.NSInclude(
				&controllers.LaneReportSurfaceController{},
			),
		),

		beego.NSNamespace("/lane_subtile",
			beego.NSInclude(
				&controllers.LaneSubtileController{},
			),
		),

		beego.NSNamespace("/lib_prep",
			beego.NSInclude(
				&controllers.LibPrepController{},
			),
		),

		beego.NSNamespace("/lib_prep_pool",
			beego.NSInclude(
				&controllers.LibPrepPoolController{},
			),
		),

		beego.NSNamespace("/lib_prep_pool_grouping",
			beego.NSInclude(
				&controllers.LibPrepPoolGroupingController{},
			),
		),

		beego.NSNamespace("/lib_prep_reagent",
			beego.NSInclude(
				&controllers.LibPrepReagentController{},
			),
		),

		beego.NSNamespace("/library_prep",
			beego.NSInclude(
				&controllers.LibraryPrepController{},
			),
		),

		beego.NSNamespace("/library_prep_type",
			beego.NSInclude(
				&controllers.LibraryPrepTypeController{},
			),
		),

		beego.NSNamespace("/migrations",
			beego.NSInclude(
				&controllers.MigrationsController{},
			),
		),

		beego.NSNamespace("/project",
			beego.NSInclude(
				&controllers.ProjectController{},
			),
		),

		beego.NSNamespace("/project_analysis",
			beego.NSInclude(
				&controllers.ProjectAnalysisController{},
			),
		),

		beego.NSNamespace("/project_flowcell",
			beego.NSInclude(
				&controllers.ProjectFlowcellController{},
			),
		),

		beego.NSNamespace("/project_flowcell_resource",
			beego.NSInclude(
				&controllers.ProjectFlowcellResourceController{},
			),
		),

		beego.NSNamespace("/project_status",
			beego.NSInclude(
				&controllers.ProjectStatusController{},
			),
		),

		beego.NSNamespace("/request",
			beego.NSInclude(
				&controllers.RequestController{},
			),
		),

		beego.NSNamespace("/request_file",
			beego.NSInclude(
				&controllers.RequestFileController{},
			),
		),

		beego.NSNamespace("/request_flowcell",
			beego.NSInclude(
				&controllers.RequestFlowcellController{},
			),
		),

		beego.NSNamespace("/request_qc",
			beego.NSInclude(
				&controllers.RequestQcController{},
			),
		),

		beego.NSNamespace("/request_reagent",
			beego.NSInclude(
				&controllers.RequestReagentController{},
			),
		),

		beego.NSNamespace("/requeue",
			beego.NSInclude(
				&controllers.RequeueController{},
			),
		),

		beego.NSNamespace("/requeue_reason",
			beego.NSInclude(
				&controllers.RequeueReasonController{},
			),
		),

		beego.NSNamespace("/requeue_type",
			beego.NSInclude(
				&controllers.RequeueTypeController{},
			),
		),

		beego.NSNamespace("/run_tracker",
			beego.NSInclude(
				&controllers.RunTrackerController{},
			),
		),

		beego.NSNamespace("/run_tracker_flowcell",
			beego.NSInclude(
				&controllers.RunTrackerFlowcellController{},
			),
		),

		beego.NSNamespace("/run_tracker_lane_genome",
			beego.NSInclude(
				&controllers.RunTrackerLaneGenomeController{},
			),
		),

		beego.NSNamespace("/run_tracker_qc",
			beego.NSInclude(
				&controllers.RunTrackerQcController{},
			),
		),

		beego.NSNamespace("/sample",
			beego.NSInclude(
				&controllers.SampleController{},
			),
		),

		beego.NSNamespace("/sample_analysis_group",
			beego.NSInclude(
				&controllers.SampleAnalysisGroupController{},
			),
		),

		beego.NSNamespace("/sample_analysis_grouping",
			beego.NSInclude(
				&controllers.SampleAnalysisGroupingController{},
			),
		),

		beego.NSNamespace("/sample_yield",
			beego.NSInclude(
				&controllers.SampleYieldController{},
			),
		),

		beego.NSNamespace("/samplesheet",
			beego.NSInclude(
				&controllers.SamplesheetController{},
			),
		),

		beego.NSNamespace("/sequencing_request",
			beego.NSInclude(
				&controllers.SequencingRequestController{},
			),
		),

		beego.NSNamespace("/sequencing_request_flowcell",
			beego.NSInclude(
				&controllers.SequencingRequestFlowcellController{},
			),
		),

		beego.NSNamespace("/sequencing_request_log",
			beego.NSInclude(
				&controllers.SequencingRequestLogController{},
			),
		),

		beego.NSNamespace("/session",
			beego.NSInclude(
				&controllers.SessionController{},
			),
		),

		beego.NSNamespace("/tile_metrics",
			beego.NSInclude(
				&controllers.TileMetricsController{},
			),
		),

		beego.NSNamespace("/user",
			beego.NSInclude(
				&controllers.UserController{},
			),
		),

		beego.NSNamespace("/user_instrument",
			beego.NSInclude(
				&controllers.UserInstrumentController{},
			),
		),

		beego.NSNamespace("/user_instrument_tag",
			beego.NSInclude(
				&controllers.UserInstrumentTagController{},
			),
		),

		beego.NSNamespace("/user_tag",
			beego.NSInclude(
				&controllers.UserTagController{},
			),
		),

		beego.NSNamespace("/user_tag_instrument",
			beego.NSInclude(
				&controllers.UserTagInstrumentController{},
			),
		),

		beego.NSNamespace("/usergroup",
			beego.NSInclude(
				&controllers.UsergroupController{},
			),
		),

		beego.NSNamespace("/usergroup_instrument",
			beego.NSInclude(
				&controllers.UsergroupInstrumentController{},
			),
		),

		beego.NSNamespace("/usergroup_members",
			beego.NSInclude(
				&controllers.UsergroupMembersController{},
			),
		),

		beego.NSNamespace("/usergroup_task",
			beego.NSInclude(
				&controllers.UsergroupTaskController{},
			),
		),
	)
	beego.AddNamespace(ns)
}
