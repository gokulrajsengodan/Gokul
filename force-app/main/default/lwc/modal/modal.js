import { LightningElement,api, track } from 'lwc';

const headerStyles = {
  BASE: 'slds-theme_alert-texture slds-theme_info',
  WARNING: 'slds-theme_alert-texture slds-theme_warning',
  ERROR: 'slds-theme_error slds-theme_alert-texture',
  OFFLINE: 'slds-theme_alert-texture slds-theme_offline',
  NONE: ''
};

export default class Modal extends LightningElement {
  @api
  modalHeaderStyle;

  @api
  headerName;

  @track
  showModal = false;

  @api
  modalSize;

  @api
  hideCloseAction = false;

  @api
  contentStyle ='';

  @api
  isModalAbsolute = false;

  @track
  hasFooter = false;

  @api
  displayModal(state) {
			console.log('enterss');
    this.showModal = state;
  }

  @api
  isShowingModal() {
    return this.showModal;
  }

  hide() {
    this.showModal = false;
    this.dispatchEvent(new CustomEvent('modalclose'));
  }

  handleSlotContentChange() {
    let modalContent = this.template.querySelector('[data-id="content"]');
    if (modalContent && modalContent.classList) {
      modalContent.classList.remove('slds-hide');
    }
  }

  handleSlotFooterChange(evt) {
    let modalFooter = this.template.querySelector('[data-id="footer"]');
    if (modalFooter && modalFooter.classList) {
      modalFooter.classList.remove('slds-hide');
    }

    if (evt.target) {
      let hasFooter = 0 !== evt.target.assignedElements().length;
      let modalContent = this.template.querySelector('[data-id="content"]');
      if (modalContent && modalContent.classList) {
        if (hasFooter) {
          modalContent.classList.remove('rounded-content');
        } else {
          modalContent.classList.add('rounded-content');
        }
      }
    }
  }

  get headerStyle() {
    let headerStyle = '';

    for (let [key, value] of Object.entries(headerStyles)) {
      if (
        this.modalHeaderStyle &&
        this.modalHeaderStyle.toLowerCase() === key.toLowerCase()
      ) {
        headerStyle = value;
        break;
      }
    }

    return 'slds-modal__header ' + headerStyle;
  }

  get parentContainerStyle() {
    let headerStyle = this.isModalAbsolute
      ? 'slds-is-absolute'
      : 'slds-is-fixed';
    return 'modal-height ' + headerStyle;
  }

  get wrapperStyle() {
    let wrapperStyle = 'slds-modal slds-fade-in-open';
    if (this.modalSize) {
      wrapperStyle += ' slds-modal_' + this.modalSize.toLowerCase();
    }
    return wrapperStyle;
  }
}