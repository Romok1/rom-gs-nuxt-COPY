import Vue from 'vue'
import VueTailwind from 'vue-tailwind'

import {
  TInputGroup,
  TInput,
  TTextarea,
  TSelect,
  TRadio,
  TCheckbox,
  TButton,
  TCard,
  TAlert,
  TModal,
  TDropdown,
  TRichSelect
  // TPagination,
  // TTag,
  // TRadioGroup,
  // TCheckboxGroup,
  // TTable,
  // TDatepicker,
  // TToggle,
  // TDialog
} from 'vue-tailwind/dist/components'

const settings = {
  TInputGroup: {
    component: TInputGroup,
    props: {
      fixedClasses: {
        wrapper: 't-input-group',
        label: 't-input-group__label',
        body: 't-input-group__body',
        feedback: 't-input-group__feedback',
        description: 't-input-group__description'
      },
      classes: {
        wrapper: '',
        label: '',
        body: '',
        feedback: 't-input-group__feedback--default',
        description: ''
      },
      variants: {
        danger: {
          label: 't-input-group__label--danger',
          feedback: 't-input-group__feedback--danger'
        },
        success: {
          label: 't-input-group__label--success',
          feedback: 't-input-group__feedback--success'
        }
      }
    }
  },
  TInput: {
    component: TInput,
    props: {
      fixedClasses: 't-input',
      classes: 't-input--default',
      variants: {
        danger: 't-input--danger',
        success: 't-input--success'
      }
    }
  },
  TTextarea: {
    component: TTextarea,
    props: {}
  },
  TSelect: {
    component: TSelect,
    props: {}
  },
  TRadio: {
    component: TRadio,
    props: {}
  },
  TCheckbox: {
    component: TCheckbox,
    props: {}
  },
  TButton: {
    component: TButton,
    props: {
      fixedClasses: 't-button',
      classes: 't-button--default',
      variants: {
        secondary: 't-button--secondary',
        danger: 't-button--danger',
        success: 't-button--success'
      }
    }
  },
  TLink: {
    component: TButton,
    props: {
      fixedClasses: 't-link',
      classes: '',
      variants: {}
    }
  },
  TCard: {
    component: TCard,
    props: {}
  },
  TModal: {
    component: TModal,
    props: {
      fixedClasses: {
        overlay: 't-modal',
        wrapper: 't-modal__wrapper',
        modal: 't-modal__modal',
        body: 't-modal__body',
        header: 't-modal__header ',
        footer: 't-modal__footer ',
        close: 't-modal__close',
        closeIcon: 't-modal__close-icon'
      },
      classes: {
        overlay: '',
        wrapper: '',
        modal: '',
        body: '',
        header: '',
        footer: '',
        close: '',
        closeIcon: '',
        overlayEnterClass: 'opacity-0',
        overlayEnterActiveClass: 'transition ease-out duration-100',
        overlayEnterToClass: 'opacity-100',
        overlayLeaveClass: 'opacity-100',
        overlayLeaveActiveClass: 'transition ease-in duration-75',
        overlayLeaveToClass: 'opacity-0',
        enterClass: '',
        enterActiveClass: '',
        enterToClass: '',
        leaveClass: '',
        leaveActiveClass: '',
        leaveToClass: ''
      },
      variants: {}
    }
  },
  TDropdown: {
    component: TDropdown,
    props: {
      fixedClasses: {
        button: 't-dropdown',
        wrapper: 't-dropdown__wrapper',
        dropdownWrapper: 't-dropdown__dropdown-wrapper',
        dropdown: 't-dropdown__dropdown',
        enterClass: 't-dropdown--enter',
        enterActiveClass: 't-dropdown--enter-active',
        enterToClass: 't-dropdown--enter-to',
        leaveClass: 't-dropdown--leave',
        leaveActiveClass: 't-dropdown--leave-active',
        leaveToClass: 't-dropdown--leave-to'
      }
    }
  },
  TAccountDropdown: {
    component: TDropdown,
    props: {
      fixedClasses: {
        button: 't-account-dropdown',
        wrapper: 't-account-dropdown__wrapper',
        dropdownWrapper: 't-account-dropdown__dropdown-wrapper',
        dropdown: 't-account-dropdown__dropdown',
        enterClass: 't-account-dropdown--enter',
        enterActiveClass: 't-account-dropdown--enter-active',
        enterToClass: 't-account-dropdown--enter-to',
        leaveClass: 't-account-dropdown--leave',
        leaveActiveClass: 't-account-dropdown--leave-active',
        leaveToClass: 't-account-dropdown--leave-to'
      }
    }
  },
  TAlert: {
    component: TAlert,
    props: {
      fixedClasses: {
        wrapper: 't-alert',
        body: 't-alert__body',
        close: 't-alert__close',
        closeIcon: 't-alert__close-icon'
      },
      classes: {
        wrapper: 't-alert--default',
        body: 't-alert__body--default',
        close: 't-alert__close--default'
      },
      variants: {
        danger: {
          wrapper: 't-alert__wrapper--danger',
          body: 't-alert__body--danger',
          close: 't-alert__close--danger'
        },
        success: {
          wrapper: 't-alert__wrapper--success',
          body: 't-alert__body--success',
          close: 't-alert__close--success'
        }
      }
    }
  },
  TRichSelect: {
    component: TRichSelect,
    props: {
      fixedClasses: {
        wrapper: 't-rich-select',
        buttonWrapper: 't-rich-select__buttonWrapper',
        selectButton: 't-rich-select__selectButton',
        selectButtonLabel: 't-rich-select__selectButtonLabel',
        selectButtonTagWrapper: 't-rich-select__selectButtonTagWrapper',
        selectButtonTag: 't-rich-select__selectButtonTag',
        selectButtonTagText: 't-rich-select__selectButtonTagText',
        selectButtonTagDeleteButton: 't-rich-select__selectButtonTagDeleteButton',
        selectButtonTagDeleteButtonIcon: 't-rich-select__selectButtonTagDeleteButtonIcon',
        selectButtonPlaceholder: 't-rich-select__selectButtonPlaceholder',
        selectButtonIcon: 't-rich-select__selectButtonIcon',
        selectButtonClearButton: 't-rich-select__selectButtonClearButton',
        selectButtonClearIcon: 't-rich-select__selectButtonClearIcon',
        dropdown: 't-rich-select__dropdown',
        dropdownFeedback: 't-rich-select__dropdownFeedback',
        loadingMoreResults: 't-rich-select__loadingMoreResults',
        optionsList: 't-rich-select__optionsList',
        searchWrapper: 't-rich-select__searchWrapper',
        searchBox: 't-rich-select__searchBox',
        optgroup: 't-rich-select__optgroup',
        option: 't-rich-select__option',
        disabledOption: 't-rich-select__disabledOption',
        highlightedOption: 't-rich-select__highlightedOption',
        selectedOption: 't-rich-select__selectedOption',
        selectedHighlightedOption: 't-rich-select__selectedHighlightedOption',
        optionContent: 't-rich-select__optionContent',
        optionLabel: 't-rich-select__optionLabel',
        selectedIcon: 't-rich-select__selectedIcon',
        enterClass: '',
        enterActiveClass: '',
        enterToClass: '',
        leaveClass: '',
        leaveActiveClass: '',
        leaveToClass: ''
      },
      classes: {
        wrapper: 't-rich-select--default',
        buttonWrapper: 't-rich-select__buttonWrapper--default',
        selectButton: 't-rich-select__selectButton--default',
        selectButtonLabel: 't-rich-select__selectButtonLabel--default',
        selectButtonPlaceholder: 't-rich-select__selectButtonPlaceholder--default',
        selectButtonIcon: 't-rich-select__selectButtonIcon--default',
        selectButtonClearButton: 't-rich-select__selectButtonClearButton--default',
        selectButtonClearIcon: 't-rich-select__selectButtonClearIcon--default',
        dropdown: 't-rich-select__dropdown--default',
        dropdownFeedback: 't-rich-select__dropdownFeedback--default',
        loadingMoreResults: 't-rich-select__loadingMoreResults--default',
        optionsList: 't-rich-select__optionsList--default',
        searchWrapper: 't-rich-select__searchWrapper--default',
        searchBox: 't-rich-select__searchBox--default',
        optgroup: 't-rich-select__optgroup--default',
        option: 't-rich-select__option--default',
        disabledOption: 't-rich-select__disabledOption--default',
        highlightedOption: 't-rich-select__highlightedOption--default',
        selectedOption: 't-rich-select__selectedOption--default',
        selectedHighlightedOption: 't-rich-select__selectedHighlightedOption--default',
        optionContent: 't-rich-select__optionContent--default',
        optionLabel: 't-rich-select__optionLabel--default',
        selectedIcon: 't-rich-select__selectedIcon--default',
        enterClass: 'opacity-0',
        enterActiveClass: 'transition ease-out duration-100',
        enterToClass: 'opacity-100',
        leaveClass: 'opacity-100',
        leaveActiveClass: 'transition ease-in duration-75',
        leaveToClass: 'opacity-0'
      },
      variants: {
        danger: {
          selectButton: 't-rich-select__selectButton--danger',
          selectButtonPlaceholder: 't-rich-select__selectButtonPlaceholder--danger',
          selectButtonIcon: 't-rich-select__selectButtonIcon--danger',
          selectButtonClearButton: 't-rich-select__selectButtonClearButton--danger',
          dropdown: 't-rich-select__dropdown--danger'
        },
        success: {
          selectButton: 't-rich-select__selectButton--success',
          selectButtonIcon: 't-rich-select__selectButtonIcon--success',
          selectButtonClearButton: 't-rich-select__selectButtonClearButton--success',
          dropdown: 't-rich-select__dropdown--success'
        }
      }
    }
  }
}

Vue.use(VueTailwind, settings)
