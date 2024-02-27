import { LightningElement } from 'lwc';
import getAccount from '@salesforce/apex/RecordDownloader.getAccount';
import sheetJs from '@salesforce/resourceUrl/sheetJs';
import { loadScript } from 'lightning/platformResourceLoader';

export default class DownloadRecordInExcel extends LightningElement {
    async connectedCallback() {
        await loadScript(this, sheetJs);
    }

    downloadRecord() {
        getAccount({}).then(result => {
            if (result) {
                console.log('result==', result);
                try {
                    this.accountRecord = result;
                    const excelFileName = 'Accounts.xlsx';
                    // creates a new empty Excel workbook object Provided by sheetJS library.
                    const workbook = XLSX.utils.book_new();

                    // Sheet 1: First 10 records
                    let headerRowSheet1 = ['Name', 'Phone', 'Type'];
                    const worksheetDataSheet1 = [headerRowSheet1]; // Initialize with header row
                    this.accountRecord.slice(0, 10).forEach(record => {
                        const rowData = [record.Name, record.Phone, record.Type || ''];
                        worksheetDataSheet1.push(rowData);
                    });
                    // it will convert array of arrays into excel worksheet format provided by sheetJS library
                    const worksheetSheet1 = XLSX.utils.aoa_to_sheet(worksheetDataSheet1);
                    // it will decide the size of the column
                    const columnWidthsSheet1 = [{ wpx: 200 }, { wpx: 150 }, { wpx: 150 }];
                    // '!cols' is special key in the worksheet object that allows you to specify column widths. provided by sheetjs library
                    worksheetSheet1['!cols'] = columnWidthsSheet1;
                    const sheetNameSheet1 = '1st-Sheet Account';
                    // This is a function provided by the SheetJS library (XLSX). It is used to append a worksheet to an Excel workbook.
                    XLSX.utils.book_append_sheet(workbook, worksheetSheet1, sheetNameSheet1);

                    // Sheet 2: Records 11 to 21
                    let headerRowSheet2 = ['Name', 'Phone', 'Type'];
                    const worksheetDataSheet2 = [headerRowSheet2]; // Initialize with header row
                    this.accountRecord.slice(10, 21).forEach(record => {
                        const rowData = [record.Name, record.Phone, record.Type || ''];
                        worksheetDataSheet2.push(rowData);
                    });
                    const worksheetSheet2 = XLSX.utils.aoa_to_sheet(worksheetDataSheet2);
                    const columnWidthsSheet2 = [{ wpx: 200 }, { wpx: 150 }, { wpx: 150 }];
                    worksheetSheet2['!cols'] = columnWidthsSheet2;
                    const sheetNameSheet2 = '2nd-Sheet Account';
                    XLSX.utils.book_append_sheet(workbook, worksheetSheet2, sheetNameSheet2);

                    //provided by the SheetJS library, workbook data into a binary format that represents an Excel file.
                    const excelInBinarary = XLSX.write(workbook, { bookType: 'xlsx', type: 'array' });

                    // Conver binary to blob and type will check whether it's binaray valid or not
                    const blob = new Blob([excelInBinarary], { type: 'application/octet-stream' });
                    const a = document.createElement('a');
                    a.href = URL.createObjectURL(blob);
                    a.download = excelFileName; // Changed to excelFileName
                    document.body.appendChild(a); // Append anchor to body
                    a.click();
                    document.body.removeChild(a); // Remove anchor after click
                }
                catch (error) {
                    console.log('error caught= ', error);
                }
            }
        });
    }
}