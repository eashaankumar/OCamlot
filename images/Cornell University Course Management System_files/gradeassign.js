/* Functions for the gradeassign page */

/* Manages checkboxes for selecting groups */

var pendings= null;
var ungraded= null;

/*  ---------------------- CHECKBOX FUN BY BARMISH -----------------------*/
function selectAll(aid) {
	var gradestable= getElementById('grades_table_' + aid);
	var boxes= gradestable.getElementsByTagName('input');
	for (i= 0; i != boxes.length; i++) {
		if (boxes[i].disabled==false) {
			boxes[i].checked= true;
		}
	}
}

function selectNone(aid) {
	var gradestable= getElementById('grades_table_' + aid);
	var boxes= gradestable.getElementsByTagName('input');
	for (i= 0; i != boxes.length; i++) {
		boxes[i].checked= false;
	}
}

function selectPending(aid) {
	selectNone(aid);
	var gradestable= getElementById('grades_table_' + aid);
	var rows= gradestable.rows;
	for (i= 0; i != rows.length; i++) {
		if (rows[i].className.indexOf('pending') != -1) {
			if (rows[i].getElementsByTagName('input').item(0).disabled==false) {
				rows[i].getElementsByTagName('input').item(0).checked=true;
			}
		}    
	}
}


function selectUngraded(aid) {
	selectNone(aid);
	var gradestable= getElementById('grades_table_' + aid);
	var rows= gradestable.rows;
	for (i= 0; i != rows.length; i++) {
		if (rows[i].className.indexOf('ungraded') != -1){
			if (rows[i].getElementsByTagName('input').item(0).disabled==false) {
				rows[i].getElementsByTagName('input').item(0).checked=true;
			}
		}    
	}  
}

function selectRange(aid,a,b,max) {
	var first, second;
	if (a=="") first= 1;
	else      first= parseInt(a);
	if (b=="") second= max;
	else      second= parseInt(b);

	if (!(isNaN(first) || isNaN(second))) { 
		if (first<1) first=1;
		if (second>max) second=max;

		if (second<first)
			selectNone(aid);
		else {
			selectNone(aid);

			var gradestable= getElementById('grades_table_' + aid);
			var rows= gradestable.rows;
			for (i= first+1; i != second+2; i++) {
				if (rows[i].getElementsByTagName('input').item(0).disabled==false) {
					rows[i].getElementsByTagName('input').item(0).checked=true;
				}
			}  



		}     
	} 
}  



/*  ---------------------- END CHECKBOX FUN BY BARMISH -----------------------*/



/* Show problem grades onclick handler */
function showProblemGrades(aid) {
	// Set link to hide grades
	var probgrades= getElementById('subgrades');
	var link= probgrades.getElementsByTagName('a').item(1);
	var linktxt= link.firstChild;
	var txt= document.createTextNode('(Hide Problem Scores)');
	link.replaceChild(txt, linktxt);
	link.onclick= new Function('return hideProblemGrades(' + aid + ');');

	// Set colspans & sortables
	var gradeheader= getElementById('gradeheader');
	gradeheader.colSpan = 1 + numprobs;
	gradeheader.className= 'nosort';
	var gradespace= getElementById('gradespace');
	gradespace.colSpan=1;

	//change display property
	var gradestable= getElementById('grades_table_' + aid);
	for (var i = 0; i < gradestable.rows.length; i++)
		for (var j = 0; j < gradestable.rows[i].cells.length; j++)
			if (gradestable.rows[i].cells[j].className.indexOf('prob_score_cell') != -1)
				gradestable.rows[i].cells[j].style.display = '';
	// Redo sortability
	ts_makeSortable(gradestable);

	return false;
}

/* Hide problem grades onclick handler */
function hideProblemGrades(aid) {
	// Set link to show grades
	var probgrades= getElementById('subgrades');
	var link= probgrades.getElementsByTagName('a').item(1);
	var linktxt= link.firstChild;
	var txt= document.createTextNode('(Show Problem Scores)');
	link.replaceChild(txt, linktxt);
	link.onclick= new Function('return showProblemGrades(' + aid + ');');

	// Set colspans & sortables
	var gradeheader= getElementById('gradeheader');
	gradeheader.colSpan= 1;
	gradeheader.className= 'scores';
	var gradespace= getElementById('gradespace');
	gradespace.colSpan=2;
	//change display property
	var gradestable= getElementById('grades_table_' + aid);
	for (var i = 0; i < gradestable.rows.length; i++)
		for (var j = 0; j < gradestable.rows[i].cells.length; j++)
			if (gradestable.rows[i].cells[j].className.indexOf('prob_score_cell') != -1)
				gradestable.rows[i].cells[j].style.display = 'none';

	// Redo sortability
	ts_makeSortable(gradestable);

	return false;
}

/*
select groups assigned to the given grader for the given problem(s),
if the element with problemSelectID exists; if it doesn't, look
for groups assigned to the given grader for any problem
 */
function selectAssignedTo(graderSelectID, problemSelectID, assignID, numProbs, showslip)
{
	var graderSelector = getElementById(graderSelectID);
	var grader = graderSelector.options[graderSelector.selectedIndex].value; //netID of selected grader
	if (grader =='<unassigned>') grader = '';
	var graderRegexp = new RegExp('\\s*' + grader + '\\s*');
	var problemSelector = getElementById(problemSelectID);
	var probs;
	if (problemSelector != null)
	{
		probs = new Array(problemSelector.options.length); //will map indices to bools
		for (var i = 0; i < problemSelector.options.length; i++) {
			probs[i] = problemSelector.options[i].selected;
		}
	}
	else
	{
		probs = new Array(1);
		probs[0] = true;
	}
	// Reset selection
	selectNone(assignID);
	var gradesTable = getElementById('grades_table_' + assignID);
	var groupRows = gradesTable.tBodies[0].rows;
	for (var i = 2; i < groupRows.length; i++) //first two rows are header stuff
	{
		var assignedToIndex = (showslip) ? 7 : 6; //index of first cell with assigned-to info
		var numAssignedToCells;
		if (problemSelector == null) //there are no problems
			numAssignedToCells = 1;
		else numAssignedToCells = numProbs;
		for (var j = 0; j < numAssignedToCells; j++)
		{
			var cell = groupRows[i].cells[j + assignedToIndex];
			var divs = cell.getElementsByTagName('div');
			if (divs.length > 0) //there's an assigned grader
			{
				if (grader != '') //we're looking for an assigned grader
				{
					var assignedGrader = divs[0].firstChild.nodeValue; //should be a netID
					if (probs[j] && assignedGrader.match(graderRegexp))
					{
						//check the checkbox at the beginning of the row
						var checkbox = groupRows[i].cells[1].getElementsByTagName('input')[0];
						checkbox.checked = true;
					}
				}
			}
			else //no assigned grader
			{
				if (grader == '' && probs[j]) //we're looking for unassigned people
				{
					//check the checkbox at the beginning of the row
					var checkbox = groupRows[i].cells[1].getElementsByTagName('input')[0];
					checkbox.checked = true;
				}
			}
		}
	}
}

function showHideAssignedTo() {
  	var i = 0;
	var cell = getElementById('assigned_' + i);
	while (cell != null) {
  		if (cell.style.display=='none') {
  			cell.style.display='';
  		} else {
  			cell.style.display='none';
		}
		i = i + 1;
		cell = getElementById('assigned_' + i);
  	}
  	link= getElementById('show_assignedto');
  	var txt = link.firstChild;
  	if (txt.nodeValue == '(Show Assigned To)') {
  		txt.nodeValue = '(Hide Assigned To)';
  		setCookie('showAssignedTo', 1, null);
  	} else {
  		txt.nodeValue = '(Show Assigned To)';
  		setCookie('showAssignedTo', 0, null);
  	}
  }

function showHideSlipDays() {
	var i = 0;
	var cell = getElementById('slipdays_' + i);
	while (cell != null) {
		if (cell.style.display=='none') {
			cell.style.display='';
		} else {
			cell.style.display='none';
		}
		i = i + 1;
		cell = getElementById('slipdays_' + i);
	}
	link= getElementById('show_slipdays');
	var txt = link.firstChild;
	if (txt.nodeValue == '(Show Slip Days)') {
		txt.nodeValue = '(Hide Slip Days)';
		setCookie('showSlipDays', 1, null);
	} else {
		txt.nodeValue = '(Show Slip Days)';
		setCookie('showSlipDays', 0, null);
	}
}

function checkGrouping(aid, maxnum) {
	var gradestable= getElementById('grades_table_' + aid);
	var boxes= gradestable.getElementsByTagName('input');
	var count = 0;
	var multStudents = false;
	for (i= 0; i != boxes.length; i++) {
		if (boxes[i].checked) {
			var row = boxes[i].parentElement.parentElement;
			var numStudents = row.children[2].getElementsByTagName("a").length;
			if (numStudents > 1) {
				multStudents = true;
			}
			count += numStudents;
		}
	}
	if (count == 0) {
		alert("No groups selected");
		return false;
	} else if (multStudents) {
		return confirm("Warning: you are about to group " + count
				+ " students, some of whom are already in groups. Proceed?");
	} else if (count > maxnum) {
		return confirm("Warning: you are about to group "
				+ count + " students (Assignment's limit is "
				+ maxnum + "). Proceed?");
	}
	return true;
}

function checkUngrouping(aid) {
	var gradestable= getElementById('grades_table_' + aid);
	var boxes= gradestable.getElementsByTagName('input');
	count = 0;
	for (i= 0; i != boxes.length; i++) {
		if (boxes[i].checked) {
			count++;
		}
	}
	if (count == 0) {
		alert("No groups selected");
		return false;
	} else if (count > 1) {
		return confirm("Warning: you are about to disband "
				+ count + " groups. Proceed?");
	}
	return true;
}

function checkMultiGrant(aid, extID) {
	var extension = getElementById(extID);
	var gradestable = getElementById('grades_table_' + aid);
	var boxes = gradestable.getElementsByTagName('input');
	count = 0;
	for (i = 0; i != boxes.length; i++) {
		if (boxes[i].checked) {
			count++;
		}
	}
	
	if (count == 0) {
		alert("No groups selected");
		return false;
	} else if (count > 1) {
		return confirm("Warning: you are about to " + ((extension.value == "") ? "remove" : "grant")
				+ " an extension for " + count + " groups. Proceed?");
	}
	return true;
	
}

function hideAssignedToByCookie() {
	if(getCookie('showAssignedTo') == '1' && getElementById('assigned_0') != null
		&& getElementById('assigned_0').style.display == 'none')
		showHideAssignedTo();
}

function hideSlipDaysByCookie() {
	if(getCookie('showSlipDays') == '1' && getElementById('slipdays_0') != null
		&& getElementById('slipdays_0').style.display == 'none')
		showHideSlipDays();
}

addLoadEvent(hideAssignedToByCookie);
addLoadEvent(hideSlipDaysByCookie);